#! @bash@/bin/sh -e

# Delete old boot folder content
rm -rf /boot/*

# Call the extlinux builder
"@extlinuxconfbuilder@" "$@"

# Add the firmware files
fwdir=@firmware@/share/raspberrypi/boot/
cp $fwdir/bootcode.bin  /boot/bootcode.bin
cp $fwdir/fixup.dat     /boot/fixup.dat
cp $fwdir/fixup_cd.dat  /boot/fixup_cd.dat
cp $fwdir/fixup_db.dat  /boot/fixup_db.dat
cp $fwdir/start.elf     /boot/start.elf
cp $fwdir/start_cd.elf  /boot/start_cd.elf
cp $fwdir/start_db.elf  /boot/start_db.elf
cp $fwdir/start_x.elf   /boot/start_x.elf

# Add the uboot file
cp @uboot@/u-boot.bin /boot/u-boot-rpi.bin

# Add the config.txt
cp @configtxt@ /boot/config.txt
