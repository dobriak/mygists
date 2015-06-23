#!/bin/bash
## Switch:
tcpdump -i eth0 -s 1500 -XX -c 1 'ether proto 0x88cc'
 
## Port and CDP Neighbor Info:
tcpdump -v -s 1500 -c 1 '(ether[12:2]=0x88cc or ether[20:2]=0x2000)'
