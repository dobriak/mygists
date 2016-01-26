#!/bin/bash
# Ping an IP address with an MTU size packet, no fragmentation
USAGE="Usage: ping_mtu.sh <MTU> <IP ADDRESS>"
: ${1?${USAGE}}
: ${2?${USAGE}}
let mtu="${1} - 28"
ping -c 3 -M do -s ${mtu} ${2}
