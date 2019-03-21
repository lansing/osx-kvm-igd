MY_OPTIONS="+pcid,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check"

qemu-system-x86_64 \
    -enable-kvm -m 10000 \
    -cpu Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$MY_OPTIONS \
	  -machine pc  \
	  -smp 4,cores=2 \
	  -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
	  -smbios type=2 \
    -device vfio-pci,host=00:02.0,bus=pci.0,addr=0x2,x-igd-opregion=on,x-vga=on,x-igd-gms=6,romfile=/home/max/Code/rom-parser/vbios.dump \
	  -device ahci,id=ahci \
    -drive id=disk0,file=/dev/disk/by-id/ata-KINGSTON_SA400S37240G_50026B77826366B7,if=none,format=raw \
    -device ide-drive,drive=disk0,bus=ahci.0 \
	  -netdev user,id=net0 -device e1000-82545em,netdev=net0,id=net0,mac=52:54:00:c9:18:27 \
    -chardev file,id=seabios,path=/tmp/bios.log \
    -device isa-debugcon,iobase=0x402,chardev=seabios \
    -usb -device usb-host,vendorid=0x1ea7,productid=0x0066 \
    -usb -device usb-host,vendorid=0x1a2c,productid=0x2124 \
    -vga none \
    -serial none \
    -nographic
