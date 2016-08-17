#!/bin/bash
# Create forwarding rules betwee internet <-> lan nics

# Internet connected nic: internet0
# LAN nic: net0
# Set net0 with static IP

sysctl net.ipv4.ip_forward=1

cat <<EOF > /etc/sysctl.d/30-ipforward.conf
net.ipv4.ip_forward=1
net.ipv6.conf.default.forwarding=1
net.ipv6.conf.all.forwarding=1
EOF

iptables -t nat -A POSTROUTING -o internet0 -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i net0 -o internet0 -j ACCEPT
