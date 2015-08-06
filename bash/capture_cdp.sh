#!/bin/bash
## This will often show you the Cisco chassis switch, then use your firms asset management software to find the upstream switch.
## -s 1500 capture 1500 bytes of the packet (typical MTU size)
## ether[20:2] == 0x2000 - Capture only packets that are starting at byte 20, and have a 2 byte value of hex 2000 
## See http://en.wikipedia.org/wiki/Cisco_Discovery_Protocol

tcpdump -v -s 1500 -c 1 'ether[20:2] == 0x2000'

# or, alternatively, yum install cdpr; cdpr -d <interface name>
