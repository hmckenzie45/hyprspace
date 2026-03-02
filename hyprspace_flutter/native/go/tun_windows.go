//go:build windows
// +build windows

package main

/*
#include <stdlib.h>
#include <stdint.h>
*/
import "C"
import (
	"fmt"
	"os/exec"
	"strings"
)

// platformCreateTun creates a Windows TUN device via the netsh utility.
// Production deployments should replace this with direct Wintun API calls
// for better performance and reliability.
func platformCreateTun(name string, address string, mtu int) C.int32_t {
	// Parse CIDR to extract IP and mask.
	parts := strings.SplitN(address, "/", 2)
	if len(parts) != 2 {
		return -1
	}
	ip := parts[0]
	prefix := parts[1]

	// Create the adapter using netsh.
	if err := runNetsh("interface", "ipv4", "set", "address",
		"name="+name, "source=static", "address="+ip,
		"mask="+prefixToMask(prefix), "gateway=none"); err != nil {
		fmt.Printf("[hyprspace] netsh set address error: %v\n", err)
		return -2
	}

	// Set MTU.
	if err := runNetsh("interface", "ipv4", "set", "subinterface",
		name, fmt.Sprintf("mtu=%d", mtu), "store=persistent"); err != nil {
		fmt.Printf("[hyprspace] netsh set MTU error: %v\n", err)
		return -3
	}

	fmt.Printf("[hyprspace] TUN adapter %s created with address %s MTU %d\n", name, address, mtu)
	return 0
}

func runNetsh(args ...string) error {
	cmd := exec.Command("netsh", args...)
	out, err := cmd.CombinedOutput()
	if err != nil {
		return fmt.Errorf("netsh %v: %w\nOutput: %s", args, err, out)
	}
	return nil
}

// prefixToMask converts a CIDR prefix length string (e.g. "24") to dotted
// decimal notation (e.g. "255.255.255.0").
func prefixToMask(prefix string) string {
	var bits int
	fmt.Sscanf(prefix, "%d", &bits)
	mask := ^uint32(0) << (32 - bits)
	return fmt.Sprintf("%d.%d.%d.%d",
		(mask>>24)&0xFF, (mask>>16)&0xFF, (mask>>8)&0xFF, mask&0xFF)
}
