FREEDISK=/dev/vdb
VGROOT=VolGroup
LVROOT=lv_root
 
mkfs.ext4 ${FREEDISK}
pvcreate ${FREEDISK}
vgextend /dev/${VGROOT} ${FREEDISK}
lvextend -l +100%FREE /dev/${VGROOT}/${LVROOT}
resize2fs /dev/${VGROOT}/${LVROOT}
