#!/bin/sh
# post-build.sh for Nanopi NEO, based on the Orange Pi PC
# 2013, Carlo Caione <carlo.caione@gmail.com>
# 2016, "Yann E. MORIN" <yann.morin.1998@free.fr>

BOARD_DIR="$( dirname "${0}" )"
MKIMAGE="${HOST_DIR}/usr/bin/mkimage"
BOOT_CMD="${BOARD_DIR}/boot.cmd"
BOOT_CMD_H="${BINARIES_DIR}/boot.scr"

#copy configuration files to image
cp $BOARD_DIR/S45ntpdate $TARGET_DIR/etc/init.d
cp $BOARD_DIR/asound.conf $TARGET_DIR/etc
cp $BOARD_DIR/interfaces $TARGET_DIR/etc/network
cp $BOARD_DIR/sun8i-h3-nanopi-neo.dtb $IMAGE_DIR/sun8i-h3-nanopi-neo.dtb


# U-Boot script
"${MKIMAGE}" -C none -A arm -T script -d "${BOOT_CMD}" "${BOOT_CMD_H}"
