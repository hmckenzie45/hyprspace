package main

/*
#include <stdlib.h>
#include <stdint.h>
*/
import "C"
import (
	"context"
	"encoding/binary"
	"fmt"
	"io"
	"net"
	"sync"
	"sync/atomic"
	"unsafe"

	"github.com/libp2p/go-libp2p"
	"github.com/libp2p/go-libp2p-core/crypto"
	"github.com/libp2p/go-libp2p-core/host"
	"github.com/libp2p/go-libp2p-core/network"
	"github.com/libp2p/go-libp2p-core/peer"
	dht "github.com/libp2p/go-libp2p-kad-dht"
)

// ---------------------------------------------------------------------------
// Global state (protected by mu)
// ---------------------------------------------------------------------------

var (
	mu          sync.RWMutex
	node        host.Host
	kadDHT      *dht.IpfsDHT
	cancelNode  context.CancelFunc

	// Routing table: VPN IP (string) -> peer.ID
	peerTable   = make(map[string]peer.ID)

	// Active streams: peer.ID (string) -> network.Stream
	activeStreams = make(map[string]network.Stream)

	// Inbound packet ring buffer
	inboundMu      sync.Mutex
	inboundPackets [][]byte

	// Statistics
	statsBytesSent     int64
	statsBytesReceived int64
)

// ---------------------------------------------------------------------------
// Exported C functions
// ---------------------------------------------------------------------------

// hyprspace_init initialises the library. Returns 0 on success.
//
//export hyprspace_init
func hyprspace_init() C.int32_t {
	// Nothing to initialise globally at this stage.
	return 0
}

// hyprspace_create_tun creates a TUN device. The actual implementation is
// platform-specific and compiled via build tags (tun_linux.go /
// tun_windows.go). This stub is overridden at link time.
//
//export hyprspace_create_tun
func hyprspace_create_tun(name *C.char, address *C.char, mtu C.int32_t) C.int32_t {
	return platformCreateTun(C.GoString(name), C.GoString(address), int(mtu))
}

// hyprspace_start_node starts the libp2p node.
//
//export hyprspace_start_node
func hyprspace_start_node(privateKeyB64 *C.char, listenPort C.int32_t) C.int32_t {
	pkStr := C.GoString(privateKeyB64)
	port := int(listenPort)

	privateKey, err := crypto.UnmarshalPrivateKey([]byte(pkStr))
	if err != nil {
		return -1
	}

	ctx, cancel := context.WithCancel(context.Background())

	ip4tcp := net.JoinHostPort("0.0.0.0", fmt.Sprint(port))
	ip6tcp := net.JoinHostPort("::", fmt.Sprint(port))

	h, err := libp2p.New(
		libp2p.Identity(privateKey),
		libp2p.ListenAddrStrings(
			"/ip4/0.0.0.0/tcp/"+fmt.Sprint(port),
			"/ip6/::/tcp/"+fmt.Sprint(port),
			"/ip4/0.0.0.0/udp/"+fmt.Sprint(port)+"/quic",
			"/ip6/::/udp/"+fmt.Sprint(port)+"/quic",
		),
	)
	if err != nil {
		cancel()
		return -2
	}
	_ = ip4tcp
	_ = ip6tcp

	// Set stream handler for the Hyprspace protocol.
	h.SetStreamHandler("/hyprspace/1.0.0", handleStream)

	// Bootstrap the DHT.
	d, err := dht.New(ctx, h)
	if err != nil {
		cancel()
		h.Close()
		return -3
	}
	if err := d.Bootstrap(ctx); err != nil {
		cancel()
		h.Close()
		return -4
	}

	mu.Lock()
	node = h
	kadDHT = d
	cancelNode = cancel
	mu.Unlock()

	return 0
}

// hyprspace_stop_node shuts down the libp2p node.
//
//export hyprspace_stop_node
func hyprspace_stop_node() {
	mu.Lock()
	defer mu.Unlock()

	if cancelNode != nil {
		cancelNode()
		cancelNode = nil
	}
	if node != nil {
		node.Close()
		node = nil
	}
	kadDHT = nil
	peerTable = make(map[string]peer.ID)
	activeStreams = make(map[string]network.Stream)
}

// hyprspace_add_peer adds a peer to the routing table. Returns 0 on success.
//
//export hyprspace_add_peer
func hyprspace_add_peer(peerIDStr *C.char, peerIPStr *C.char) C.int32_t {
	id := C.GoString(peerIDStr)
	ip := C.GoString(peerIPStr)

	pid, err := peer.Decode(id)
	if err != nil {
		return -1
	}

	mu.Lock()
	peerTable[ip] = pid
	mu.Unlock()
	return 0
}

// hyprspace_remove_peer removes a peer from the routing table.
//
//export hyprspace_remove_peer
func hyprspace_remove_peer(peerIDStr *C.char) C.int32_t {
	id := C.GoString(peerIDStr)
	pid, err := peer.Decode(id)
	if err != nil {
		return -1
	}

	mu.Lock()
	// Remove by value
	for ip, p := range peerTable {
		if p == pid {
			delete(peerTable, ip)
		}
	}
	// Close active stream if exists
	if s, ok := activeStreams[pid.String()]; ok {
		s.Close()
		delete(activeStreams, pid.String())
	}
	mu.Unlock()
	return 0
}

// hyprspace_send_packet routes a raw IP packet to the appropriate peer stream.
//
//export hyprspace_send_packet
func hyprspace_send_packet(data *C.uint8_t, length C.int32_t) C.int32_t {
	n := int(length)
	if n < 20 {
		return -1 // too short for an IPv4 header
	}
	buf := C.GoBytes(unsafe.Pointer(data), C.int(n))

	// Extract destination IP from the IPv4 header (bytes 16-19).
	dstIP := net.IP(buf[16:20]).String()

	mu.RLock()
	pid, ok := peerTable[dstIP]
	mu.RUnlock()
	if !ok {
		return -2 // no route
	}

	stream, err := getOrOpenStream(pid)
	if err != nil {
		return -3
	}

	// Prefix the packet with a 4-byte length header.
	header := make([]byte, 4)
	binary.LittleEndian.PutUint32(header, uint32(n))
	if _, err := stream.Write(append(header, buf...)); err != nil {
		mu.Lock()
		stream.Close()
		delete(activeStreams, pid.String())
		mu.Unlock()
		return -4
	}

	atomic.AddInt64(&statsBytesSent, int64(n))
	return 0
}

// hyprspace_receive_packet copies the next inbound packet into buffer.
// Returns the number of bytes written, 0 if no packet is pending, or -1
// on error.
//
//export hyprspace_receive_packet
func hyprspace_receive_packet(buffer *C.uint8_t, bufferSize C.int32_t) C.int32_t {
	inboundMu.Lock()
	defer inboundMu.Unlock()

	if len(inboundPackets) == 0 {
		return 0
	}
	pkt := inboundPackets[0]
	inboundPackets = inboundPackets[1:]

	n := len(pkt)
	if n > int(bufferSize) {
		n = int(bufferSize)
	}
	dst := (*[1 << 30]byte)(unsafe.Pointer(buffer))[:n:n]
	copy(dst, pkt[:n])
	return C.int32_t(n)
}

// hyprspace_get_stats_bytes writes cumulative bytes sent and received
// into the provided pointers.
//
//export hyprspace_get_stats_bytes
func hyprspace_get_stats_bytes(bytesSent *C.int64_t, bytesReceived *C.int64_t) {
	*bytesSent = C.int64_t(atomic.LoadInt64(&statsBytesSent))
	*bytesReceived = C.int64_t(atomic.LoadInt64(&statsBytesReceived))
}

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

func getOrOpenStream(pid peer.ID) (network.Stream, error) {
	mu.RLock()
	s, ok := activeStreams[pid.String()]
	mu.RUnlock()
	if ok {
		return s, nil
	}

	mu.RLock()
	h := node
	mu.RUnlock()
	if h == nil {
		return nil, fmt.Errorf("node not started")
	}

	ctx := context.Background()
	s, err := h.NewStream(ctx, pid, "/hyprspace/1.0.0")
	if err != nil {
		return nil, err
	}

	mu.Lock()
	activeStreams[pid.String()] = s
	mu.Unlock()
	return s, nil
}

func handleStream(s network.Stream) {
	defer s.Close()
	header := make([]byte, 4)
	for {
		if _, err := io.ReadFull(s, header); err != nil {
			return
		}
		pktLen := binary.LittleEndian.Uint32(header)
		if pktLen == 0 || pktLen > 65535 {
			return
		}
		pkt := make([]byte, pktLen)
		if _, err := io.ReadFull(s, pkt); err != nil {
			return
		}
		atomic.AddInt64(&statsBytesReceived, int64(pktLen))

		inboundMu.Lock()
		inboundPackets = append(inboundPackets, pkt)
		inboundMu.Unlock()
	}
}

func main() {}
