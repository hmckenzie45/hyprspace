//go:build linux
// +build linux

package main

/*
#include <stdlib.h>
#include <stdint.h>
*/
import "C"
import (
	"fmt"

	"github.com/songgao/water"
	"github.com/vishvananda/netlink"
)

// platformCreateTun creates a Linux TUN device using the water and netlink
// libraries. It sets the IP address, MTU and brings the interface up.
func platformCreateTun(name string, address string, mtu int) C.int32_t {
	cfg := water.Config{
		DeviceType: water.TUN,
		PlatformSpecificParams: water.PlatformSpecificParams{
			Name: name,
		},
	}
	iface, err := water.New(cfg)
	if err != nil {
		return -1
	}
	_ = iface // TUN fd is managed by the OS; packets are handled by the libp2p stream.

	link, err := netlink.LinkByName(name)
	if err != nil {
		return -2
	}

	addr, err := netlink.ParseAddr(address)
	if err != nil {
		return -3
	}
	if err := netlink.AddrAdd(link, addr); err != nil {
		return -4
	}

	if err := netlink.LinkSetMTU(link, mtu); err != nil {
		return -5
	}

	if err := netlink.LinkSetUp(link); err != nil {
		return -6
	}

	fmt.Printf("[hyprspace] TUN device %s created with address %s MTU %d\n", name, address, mtu)
	return 0
}
