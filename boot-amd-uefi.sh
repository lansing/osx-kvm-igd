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

qemu-system-x86_64 -enable-kvm -m 16384 -cpu Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$MY_OPTIONS\
	  -machine pc-q35-2.11 \
	  -smp 12,cores=2 \
	  -drive if=pflash,format=raw,readonly,file=/home/max/Code/osx-kvm-igd/OVMF/OVMF_CODE.fd \
	  -drive if=pflash,format=raw,file=/home/max/Code/osx-kvm-igd/OVMF/OVMF_VARS.fd \
    -device vfio-pci,host=01:00.0,addr=0x16,romfile=/home/max/Code/osx-kvm-igd/wx-4100.rom \
    -device vfio-pci,host=02:00.0,x-msix-relocation=bar2 \
    -drive id=disk1,file=/dev/disk/by-id/ata-KINGSTON_SA400S37240G_50026B77826366B7,if=none,format=raw \
    -device ide-drive,drive=disk1,bus=ide.0 \
	  -netdev user,id=net0 -device e1000-82545em,netdev=net0,id=net0,addr=0x05,mac=52:54:00:c9:18:27 \
    -object input-linux,id=mouse1,evdev=/dev/input/by-id/usb-Logitech_USB-PS_2_Trackball-event-mouse \
    -object input-linux,id=kbd1,evdev=/dev/input/by-id/usb-04d9_USB-HID_Keyboard-event-kbd,grab_all=on,repeat=on \
	  -monitor stdio \
    -serial none \
    -vga none \
    -nographic

