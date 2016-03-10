#!/bin/bash
#To be run in Arista bash environment

#Back up startup config
timestamp=`date +%Y%m%d-%H%M%S`
scp /mnt/flash/startup-config <USER>@<Machine ip/name>:Path/To/Dir/${timestamp}-startup-config
