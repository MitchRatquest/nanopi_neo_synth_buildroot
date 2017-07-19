#!/bin/bash
#after you git clone run this
topdir=$( pwd )
#################################################
######YOU NEED SUBVERSION INSTALLED##############
#################################################


VERSION=2017.05-rc2
if [ ! -d buildroot-"$VERSION" ]
then
	wget https://git.busybox.net/buildroot/snapshot/buildroot-"$VERSION".tar.gz
	tar zvxf buildroot-"$VERSION".tar.gz
fi

patch -p1 < 0000-add-pd-tk.patch

if [ ! -d "gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf" ]
then
	echo "#############################################"
	echo "###### DOWNLOADING EXTERNAL TOOLCHAIN #######"
	echo "#############################################"
	wget https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabihf/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf.tar.xz
	tar -xf gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf.tar.xz
	rm gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf.tar.xz
fi
# ($(TOPDIR)/../gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf) Toolchain path  

if [ ! -f "linux-3.4.112.tar.gz" ]
then
	echo "#############################################"
	echo "######### DOWNLOADING LINUX SOURCES #########"
	echo "#############################################"
	wget https://github.com/armbian/linux/archive/4075887a50b0b7d85db8e03f458620dac0c91a0d.tar.gz
	mv 4075887a50b0b7d85db8e03f458620dac0c91a0d.tar.gz linux-3.4.112.tar.gz
	rm index.html
fi
#	Kernel version (Custom tarball)  --->
#(127.0.0.1:8000/linux-3.4.112.tar.gz) URL of custom kernel tarball
#($(TOPDIR)/../patches/kernel-3.4.112) Custom kernel patches
#	Kernel configuration (Using a custom (def)config file)  --->
#($(TOPDIR)/../linux-sun8i-default.config) Configuration file path

#        [*] U-Boot                                                                        │ │  
#  │ │                 Build system (Kconfig)  --->                                                │ │  
#  │ │                 U-Boot Version (Custom Git repository)  --->                                │ │  
#  │ │           (git://git.denx.de/u-boot.git) URL of custom repository                           │ │  
#  │ │           (v2017.05) Custom repository version                                              │ │  
#  │ │           ($(TOPDIR)/../patches/u-boot) Custom U-Boot patches                               │ │  
#  │ │                 U-Boot configuration (Using an in-tree board defconfig file)  --->          │ │  
#  │ │           (nanopi_neo) Board defconfig                                                      │ │  
#  │ │           [*]   U-Boot needs dtc                                              


#run a python server on localhost for grabbing the tarballs
screen -dmS server python -m SimpleHTTPServer

#wont find this when it builds for some reason
#directory doesn't exist yet
if [ ! -d "images" ]
then
	mkdir images 
fi

cp nanopi_neo_synth/sun8i-h3-nanopi-neo.dtb images/

make O=$PWD -C buildroot-2017.05-rc2/ defconfig BR2_DEFCONFIG=../configs/3.4.112-rt-buildroot.config

make

#now we have to change the boot settings to a known working configuration
#I didnt spend the time to get this working out of buildroot's system
#
#sudo fdisk -l sdcard.img
#Disk sdcard.img: 171 MiB, 179306496 bytes, 350208 sectors
#Units: sectors of 1 * 512 = 512 bytes
#Sector size (logical/physical): 512 bytes / 512 bytes
#I/O size (minimum/optimal): 512 bytes / 512 bytes
#Disklabel type: dos
#Disk identifier: 0x00000000
#
#Device      Boot Start    End Sectors Size Id Type
#sdcard.img1 *     2048  22527   20480  10M  c W95 FAT32 (LBA)
#sdcard.img2      22528 153599  131072  64M 83 Linux

#The output tells us where the boot sector is
#multiply the sector size by the start block and you have your offset
#in this case, the boot partition is 2048*512, so use 1048576 as offset
#use the loop and offset flags in mount to modify the files on the SD card

sudo su
cd $topdir/images/
if [ ! -d "tmp" ]
then
	mkdir tmp 
fi
#automatically calculate offsets if you change your partition sizes
#boot is always FAT32
mount -o loop,offset="$(($(sudo fdisk -l sdcard.img | grep -w "FAT32" | awk '{print $3}')*512))" sdcard.img tmp

rm tmp/sun8i-h3-nanopi-neo.dtb			#these files never worked for me
rm tmp/boot.scr
cp ../nanopi_neo_synth/workingboot/boot.cmd tmp/	#shamelessly stolen from a working legacy armbian image
cp ../nanopi_neo_synth/workingboot/boot.scr tmp/	
cp ../nanopi_neo_synth/workingboot/script.bin tmp/
umount tmp/ 

#mount the root partition (should handlew this with buildroot proper)
mount -o loop,offset="$(($(sudo fdisk -l sdcard.img | grep -w "Linux" | awk '{print $2}')*512))" sdcard.img tmp
cd tmp
ln -s /usr/bin/wish8.6 /usr/bin/wish
cd ../..
umount tmp/

echo "#########################################"
echo "########### BUILD COMPLETE ##############"
echo "#########################################"

