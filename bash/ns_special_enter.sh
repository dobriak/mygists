#!/bin/bash
# Entering a namespace with a security/apparmor/libvirt error

/opt/local/bin/nsenter -t $(ps ho pid --ppid $(</var/run/libvirt/lxc/plumgrid.pid)) -m -n -u -i -p /bin/bash
