#!/bin/bash

SDCARD=/dev/sdcard
MNT=/mnt/extSdCard

if [ "$ACTION" = "add" ]; then
	chmod 755 /storage
	if [ -b /dev/mmcblk1p1 ]; then
		ln -sf /dev/mmcblk1p1 $SDCARD
	elif [ -b /dev/mmcblk1 ]; then
		ln -sf /dev/mmcblk1 $SDCARD
	else 
		exit $?
	fi	
	mount $SDCARD $MNT
else
	umount $MNT

	if [ $? = 0 ]; then
		rm -f $SDCARD
	else
		umount -l $MNT
		rm -f $SDCARD
	fi
fi

