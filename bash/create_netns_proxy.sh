#!/bin/bash
echo "This script creates a network namespace called proxy, then bridges a vlan into it." 
echo "Also, it bridges a pxe/internet as well."
echo "If run on a hypervisor, the pxe/internet bridge (192.168.20.10) can be used a gateway for vms."
echo "In this case vlan 20 can be used as external network for an OS installation."
echo "The virtual nics can be used by kvm as a direct (untagged) connection for vms as well"
ip netns add proxy
ip netns exec proxy ip link set dev lo up

#1) Bridge vlan20 and proxy
ip link add proxy-sw type veth peer name proxy-ns
ip link set proxy-ns netns proxy
#ip netns exec proxy ip link add name proxy-vlan20 link proxy-ns type vlan id 20
#ip netns exec proxy ip addr add 192.168.20.10/24 dev proxy-vlan20
ip netns exec proxy ip addr add 192.168.20.10/24 dev proxy-ns
ip link set dev proxy-sw master br-vlan20
ip link set dev proxy-sw up
ip netns exec proxy ip link set proxy-ns up
#ip netns exec proxy ip link set proxy-vlan20 up
ip link set dev proxy-sw mtu 1580

#2) Bridge pxe-inet and proxy
ip link add veth-a type veth peer name veth-b
ip link set veth-b netns proxy
ip netns exec proxy ip addr add 10.22.18.10/24 dev veth-b
ip link set dev veth-a master br-pxe-inet
ip link set dev veth-a up
ip netns exec proxy ip link set dev veth-b up
ip netns exec proxy ip route add default via 10.22.18.1
ip netns exec proxy echo 1 > /proc/sys/net/ipv4/ip_forward
ip netns exec proxy iptables -t nat -A POSTROUTING -o veth-b -j MASQUERADE
#ip netns exec proxy iptables -A FORWARD -i proxy-vlan20 -o veth-b -m state --state RELATED,ESTABLISHED -j ACCEPT
ip netns exec proxy iptables -A FORWARD -i proxy-ns -o veth-b -m state --state RELATED,ESTABLISHED -j ACCEPT
#ip netns exec proxy iptables -A FORWARD -i proxy-vlan20 -o veth-b -j ACCEPT
ip netns exec proxy iptables -A FORWARD -i proxy-ns -o veth-b -j ACCEPT

echo "Done"
ip netns exec proxy ip a
