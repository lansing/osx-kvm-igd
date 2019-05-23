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

QEMU_SYSTEM=qemu-system-x86_64

QEMU_31=/mnt/home/max/Code/qemu-3.1/x86_64-softmmu/qemu-system-x86_64
QEMU_31_AUDIO=/home/max/Code/qemu-3.1-audio/x86_64-softmmu/qemu-system-x86_64
QEMU_4=/mnt/home/max/Code/qemu/x86_64-softmmu/qemu-system-x86_64

echo 1 > /sys/module/kvm/parameters/ignore_msrs

MY_OPTIONS="+pcid,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check"

#LD_LIBRARY_PATH=/mnt/usr/local/lib $QEMU_31
$QEMU_SYSTEM -enable-kvm -m 8192 -cpu Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$MY_OPTIONS\
    -machine pc-q35-2.11 \
    -smp 4,cores=2 \
    -drive if=pflash,format=raw,readonly,file=/home/max/Code/osx-kvm-igd/OVMF/OVMF_CODE.fd \
    -drive if=pflash,format=raw,file=/home/max/Code/osx-kvm-igd/OVMF/OVMF_VARS-3840x2160.fd \
    -device vfio-pci,host=03:00.0,multifunction=on,x-vga=on,romfile=/home/max/Code/osx-kvm-igd/wx-4100.rom  \
    -device vfio-pci,host=03:00.1 \
    -device vfio-pci,host=72:00.0,x-msix-relocation=bar2 \
    -drive id=clover,file=/home/max/Code/osx-kvm-igd/clover_uefi.qcow2,if=none,format=qcow2 \
    -device ide-drive,drive=clover,bus=ide.0  \
    -object input-linux,id=mouse1,evdev=/dev/input/by-id/usb-Logitech_USB-PS_2_Trackball-event-mouse \
    -object input-linux,id=kbd1,evdev=/dev/input/by-id/usb-04d9_USB-HID_Keyboard-event-kbd,grab_all=on,repeat=on \
    -monitor stdio \
    -serial none \
    -vga none \
    -nographic

