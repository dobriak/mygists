#!/bin/bash
# on the host: yum install lldpad (cdpr for cisco only stuff)
# once you run the script (make sure to verify listing of eths will work
# for your set up, run this on Arista: show lldp neighbors
for i in `ls /sys/class/net/ | grep en`; do
  echo "enabling lldp on $i";
      lldptool set-lldp -i $i adminStatus=rxtx  ;
      lldptool -T -i $i -V  sysName enableTx=yes;
      lldptool -T -i $i -V  portDesc enableTx=yes ;
      lldptool -T -i $i -V  sysDesc enableTx=yes;
      lldptool -T -i $i -V sysCap enableTx=yes;
      lldptool -T -i $i -V mngAddr enableTx=yes;
done
