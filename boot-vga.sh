MY_OPTIONS="+pcid,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check"

QEMU_SYSTEM=qemu-system-x86_64
QEMU_31=/home/max/Code/qemu-3.1/x86_64-softmmu/qemu-system-x86_64


# using qemu v4.0.0-rc0 right now, built with libusb v1.0.19-442-g2a7372d
QEMU_LATEST=/home/max/Code/qemu/x86_64-softmmu/qemu-system-x86_64

LD_LIBRARY_PATH=/usr/local/lib $QEMU_31 \
    -enable-kvm -m 16384 \
    -cpu Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$MY_OPTIONS \
	  -machine pc  \
	  -smp 8,cores=2 \
	  -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
	  -smbios type=2 \
	  -device ahci,id=ahci,addr=0x07 \
    -drive id=disk0,file=/home/max/Code/osx-kvm-igd/clover.qcow2,if=none,format=qcow2 \
    -device ide-drive,drive=disk0,bus=ahci.0 \
    -drive id=disk1,file=/dev/disk/by-id/ata-KINGSTON_SA400S37240G_50026B77826366B7,if=none,format=raw \
    -device ide-drive,drive=disk1,bus=ahci.1 \
    -chardev file,id=seabios,path=/tmp/bios.log \
    -netdev user,id=net0 -device e1000-82545em,netdev=net0,id=net0,mac=52:54:00:c9:19:82 \
    -device isa-debugcon,iobase=0x402,chardev=seabios \
    -usb \
    -device usb-kbd -device usb-tablet \
    -vga std \
    -serial none

