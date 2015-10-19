#!/bin/bash
## See http://en.wikipedia.org/wiki/Link_Layer_Discovery_Protocol
## Switch:
tcpdump -i eth0 -s 1500 -XX -c 1 'ether proto 0x88cc'
 
## Port and CDP Neighbor Info:
tcpdump -i eth0 -v -s 1500 -c 1 '(ether[12:2]=0x88cc or ether[20:2]=0x2000)'
