#!/bin/bash

# qemu-img create -f qcow2 mac_hdd.img 128G
#
# echo 1 > /sys/module/kvm/parameters/ignore_msrs (this is required)
#
# The "media=cdrom" part is needed to make Clover recognize the bootable ISO
# image.

############################################################################
# NOTE: Tweak the "MY_OPTIONS" line in case you are having booting problems!
############################################################################

MY_OPTIONS="+pcid,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check"

qemu-system-x86_64 -enable-kvm -m 8192 -cpu Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$MY_OPTIONS\
	  -machine pc-q35-2.11 \
	  -smp 4,cores=2 \
	  -drive if=pflash,format=raw,readonly,file=/home/max/Code/osx-kvm-igd/OVMF/OVMF_CODE.fd \
	  -drive if=pflash,format=raw,file=/home/max/Code/osx-kvm-igd/OVMF/OVMF_VARS.fd \
    -device ide-drive,bus=ide.1,drive=Hacky \
    -drive id=Hacky,file=/dev/disk/by-id/ata-KINGSTON_SA400S37240G_50026B77826366B7,if=none,format=raw \
	  -netdev user,id=net0 -device e1000-82545em,netdev=net0,id=net0,addr=0x05,mac=52:54:00:c9:18:27 \
    -usb -device usb-kbd -device usb-tablet \
	  -monitor stdio \
    -serial none \
    -vga std \

