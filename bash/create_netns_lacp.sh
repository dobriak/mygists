#!/bin/bash
# cat /etc/modprobe.d/bonding.conf
# options bonding mode=4 miimon=100 lacp_rate=1
# rmmod bonding; modprobe bonding

# pre-configured in proxyns script
#### These are bridges that GW node external interfaces are mapped to
#ip link add name gw1link type bridge
#ip link add name gw2link type bridge

ip netns add bondns
ip netns exec bondns ip link set dev lo up

GW1=`brctl show gw1link | grep gw1link | cut -f6`
GW2=`brctl show gw2link | grep gw2link | cut -f6`
echo $GW1 $GW2
ip link set $GW1 netns bondns
ip link set $GW2 netns bondns

ip netns exec bondns ip link add name bond-ns type bond
ip netns exec bondns echo 4 > /sys/class/net/bond-ns/bonding/mode
ip netns exec bondns ip link set $GW1 master bond-ns
ip netns exec bondns ip link set $GW2 master bond-ns
ip netns exec bondns ip link set dev $GW1 up
ip netns exec bondns ip link set dev $GW2 up
ip netns exec bondns ip link set dev bond-ns up

ip link add virbr7-fip type veth peer name bondns-fip
ip link set dev virbr7-fip master virbr7
ip link set dev virbr7-fip up
ip link set bondns-fip netns bondns
ip netns exec bondns ip link set dev bondns-fip up

ip netns exec bondns ip link add name bondns-br type bridge
ip netns exec bondns ip link set dev bond-ns master bondns-br
ip netns exec bondns ip link set dev bondns-fip master bondns-br

ip netns exec bondns ip addr add 172.16.109.10/24 dev bondns-br
ip netns exec bondns ip link set dev bondns-br up

ip link add veth-gwa type veth peer name veth-gwb
ip link set veth-gwb netns bondns
ip netns exec bondns ip addr add 172.16.111.10/24 dev veth-gwb
ip link set dev veth-gwa master virbr5
ip link set dev veth-gwa up
ip netns exec bondns ip link set dev veth-gwb up
ip netns exec bondns ip route add default via 172.16.111.1
ip netns exec bondns echo 1 > /proc/sys/net/ipv4/ip_forward
ip netns exec bondns iptables -t nat -A POSTROUTING -o veth-gwb -j MASQUERADE
ip netns exec bondns iptables -A FORWARD -i bondns-br -o veth-gwb -m state --state RELATED,ESTABLISHED -j ACCEPT
ip netns exec bondns iptables -A FORWARD -i bondns-br -o veth-gwb -j ACCEPT

ip netns exec bondns cat /proc/net/bonding/bond-ns
