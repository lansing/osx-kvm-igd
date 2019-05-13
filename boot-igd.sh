#!/usr/bin/env bash

MY_OPTIONS="+pcid,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check"

QEMU_SYSTEM=qemu-system-x86_64

QEMU_31=/home/max/Code/qemu-3.1/x86_64-softmmu/qemu-system-x86_64
QEMU_31_AUDIO=/home/max/Code/qemu-3.1-audio/x86_64-softmmu/qemu-system-x86_64
QEMU_4RC2=/usr/local/bin/qemu-4.0.0-rc2-system-x86_64
QEMU_4RC4=/home/max/Code/qemu-4.0-rc4/x86_64-softmmu/qemu-system-x86_64
QEMU_4=/home/max/Code/qemu-4.0.0/build/x86_64-softmmu/qemu-system-x86_64

ROM_FILE_ARG=",romfile=/home/max/Code/osx-kvm-igd/vbios-fixed.dump"

export QEMU_AUDIO_DRV='pa'
export QEMU_PA_ADJUST_LATENCY_OUT='1'
export QEMU_PA_SERVER='unix:/run/user/1000/pulse/native'
export QEMU_AUDIO_DAC_FIXED_FREQ='48000'
export QEMU_AUDIO_DAC_TRY_POLL='0'
export QEMU_AUDIO_ADC_FIXED_FREQ='48000'
export QEMU_AUDIO_ADC_TRY_POLL='0'
export QEMU_AUDIO_ADC_FIXED_CHANNELS='2'
export QEMU_ALSA_DAC_BUFFER_SIZE='2048'
export QEMU_ALSA_DAC_PERIOD_SIZE='1024'
export QEMU_AUDIO_TIMER_PERIOD='100'

LD_LIBRARY_PATH=/usr/local/lib $QEMU_SYSTEM \
    -enable-kvm -m 16384 \
    -cpu Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$MY_OPTIONS \
	  -machine pc  \
	  -smp 8,cores=2 \
	  -smbios type=2 \
    -device vfio-pci,host=00:02.0,bus=pci.0,addr=0x2,x-igd-opregion=on \
    -device vfio-pci,host=00:16.0,bus=pci.0,addr=0x10 \
    -device ich9-intel-hda -device hda-duplex \
	  -device ahci,id=ahci,addr=0x07 \
    -drive id=disk0,file=/home/max/Code/osx-kvm-igd/clover.qcow2,if=none,format=qcow2 \
    -device ide-drive,drive=disk0,bus=ahci.0 \
    -drive id=disk1,file=/dev/disk/by-id/ata-KINGSTON_SA400S37240G_50026B77826366B7,if=none,format=raw \
    -device ide-drive,drive=disk1,bus=ahci.1 \
    -chardev file,id=seabios,path=/tmp/bios.log \
    -netdev user,id=net0 \
    -device e1000-82545em,netdev=net0,id=net0,addr=0x05,mac=52:54:00:c9:19:82 \
    -device isa-debugcon,iobase=0x402,chardev=seabios \
    -object input-linux,id=mouse1,evdev=/dev/input/by-id/usb-Logitech_USB-PS_2_Trackball-event-mouse \
    -object input-linux,id=kbd1,evdev=/dev/input/by-id/usb-04d9_USB-HID_Keyboard-event-kbd,grab_all=on,repeat=on \
    -vga none \
    -serial none \
    -nographic

