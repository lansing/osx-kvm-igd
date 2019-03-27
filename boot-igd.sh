MY_OPTIONS="+pcid,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check"

QEMU_SYSTEM=qemu-system-x86_64

# using qemu v4.0.0-rc0 right now, built with libusb v1.0.19-442-g2a7372d
QEMU_LATEST=/home/max/Code/qemu/x86_64-softmmu/qemu-system-x86_64

ROM_FILE_ARG=",romfile=/home/max/Code/osx-kvm-igd/vbios.dump"

export QEMU_AUDIO_DRV='pa'
export QEMU_PA_ADJUST_LATENCY_OUT='1'
#export QEMU_PA_SERVER='unix:/tmp/pulse-socket'
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
	  -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
	  -smbios type=2 \
    -device vfio-pci,host=00:02.0,bus=pci.0,addr=0x2,x-igd-opregion=on \
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
    -usb \
    -device usb-host,vendorid=0x1ea7,productid=0x0066 \
    -device usb-host,vendorid=0x1a2c,productid=0x2124 \
    -vga none \
    -serial none \
    -nographic

