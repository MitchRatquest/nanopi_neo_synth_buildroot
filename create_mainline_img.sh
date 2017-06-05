#!/bin/bash
VERSION=2017.05-rc2

wget https://git.busybox.net/buildroot/snapshot/buildroot-"$VERSION".tar.gz
tar zvxf buildroot-"$VERSION".tar.gz

patch -p1 < 0000-add-pd-tk.patch 

chmod 755 nanopi_neo_synth/post-image.sh
chmod 755 nanopi_neo_synth/post-build.sh
chmod 755 nanopi_neo_synth/S45ntpdate

make O=$PWD -C buildroot-2017.05-rc2/ defconfig BR2_DEFCONFIG=../configs/nanopi_neo_synth_buildroot_defconfig
make
