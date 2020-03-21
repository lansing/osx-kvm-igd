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

OVMF_MINE=/home/max/Code/osx-kvm-igd/OVMF/OVMF_CODE.fd
OVMF_TEST=/home/max/Code/OSX-KVM/OVMF_CODE.fd
QEMU_SYSTEM=qemu-system-x86_64

QEMU_31=/mnt/home/max/Code/qemu-3.1/x86_64-softmmu/qemu-system-x86_64
QEMU_31_AUDIO=/home/max/Code/qemu-3.1-audio/x86_64-softmmu/qemu-system-x86_64
QEMU_4=/mnt/home/max/Code/qemu/x86_64-softmmu/qemu-system-x86_64

echo 1 > /sys/module/kvm/parameters/ignore_msrs

MY_OPTIONS="+pcid,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check"

export QEMU_AUDIO_DRV=pa
export QEMU_PA_SAMPLES=1024
export QEMU_AUDIO_TIMER_PERIOD=150
export QEMU_PA_SERVER=/run/user/1000/pulse/native

#LD_LIBRARY_PATH=/mnt/usr/local/lib $QEMU_31
$QEMU_SYSTEM -enable-kvm -m 16384 -mem-path /dev/hugepages -cpu Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$MY_OPTIONS\
    -machine pc-q35-4.0 \
    -smp 4,cores=2 \
    -drive if=pflash,format=raw,readonly,file=$OVMF_MINE \
    -drive if=pflash,format=raw,file=/home/max/Code/osx-kvm-igd/OVMF/OVMF_VARS-3840x2160.fd \
  	-device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
    -device vfio-pci,host=02:00.0,multifunction=on,x-vga=on,romfile=/home/max/Code/osx-kvm-igd/wx-4100.rom  \
    -device vfio-pci,host=02:00.1 \
    -device vfio-pci,host=72:00.0,x-msix-relocation=bar2 \
    -device vfio-pci,host=06:00.0 \
    -device vfio-pci,host=05:00.0 \
    -device ich9-ahci,id=sata \
    -drive id=clover_catalina_new,file=/home/max/Code/osx-kvm-igd/CloverNG-catalina-new.qcow2,if=none,format=qcow2 \
    -device ide-hd,drive=clover_catalina_new,bus=sata.3  \
    -netdev user,id=net0 \
    -device e1000-82545em,netdev=net0,id=net0,addr=0x08,mac=52:54:00:c9:19:82 \
    -monitor stdio \
    -serial none \
    -vga none \
    -nographic

