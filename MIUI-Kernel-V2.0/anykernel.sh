# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers
# Modified by Shaky156

## AnyKernel setup
# EDIFY properties
kernel.string=MIUI8 Kernel by shaky156 @ xda-developers
do.devicecheck=1
do.initd=1
do.modules=1
do.cleanup=1
device.name1=gemini
device.name2=Gemini
device.name3=MI5
device.name4=Mi5
device.name5=mi5

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel permissions
# set permissions for included ramdisk files
chmod -R 755 $ramdisk

## AnyKernel install
dump_boot;

# begin ramdisk changes

# init.qcom.rc
# backup_file init.qcom.rc;
# append_file init.qcom.rc "enable_wakeup 1" init.qcom.rc2;
backup_file init.target.rc;
append_file init.target.rc "sysinit" init.initd.rc1;

# end ramdisk changes

write_boot;

## end install

