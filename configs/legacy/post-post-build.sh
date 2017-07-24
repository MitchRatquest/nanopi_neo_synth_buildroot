#!/bin/bash
#post post build script
cd ../images/
if [ ! -d "tmp" ]
then
	sudo mkdir tmp 
fi
mount -o loop,offset=11534336 sdcard.img tmp #rootfs
ln -s tmp/usr/bin/wish8.6 tmp/usr/bin/wish
sed -i '/#PermitRootLogin prohibit-password/c\PermitRootLogin yes' tmp/etc/ssh/sshd_config
sed -i '/#X11Forwarding no/c\X11Forwarding yes' tmp/etc/ssh/sshd_config
sed -i '/#X11DisplayOffset 10/c\X11DisplayOffset 10' tmp/etc/ssh/sshd_config
chmod 777 tmp/etc/init.d/S45ntpdate

umount tmp
mount -o loop,offset=1048576 sdcard.img tmp #boot
rm tmp/sun8i-h3-nanopi-neo.dtb
cp ../nanopi_neo_synth/sun8i-h3-nanopi-neo.dtb tmp/sun8i-h3-nanopi-neo.dtb
umount tmp/
cd ..
exit 0
