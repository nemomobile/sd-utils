#!/bin/bash

SDCARD=/dev/sdcard
#MNT=/media/$ID_FS_UUID
MNT=/run/user/100000/media/sdcard

if [ "$ACTION" = "add" ]; then
	if [ -b /dev/mmcblk1p1 ]; then
		ln -sf /dev/mmcblk1p1 $SDCARD
	elif [ -b /dev/mmcblk1 ]; then
		ln -sf /dev/mmcblk1 $SDCARD
	else 
		exit $?
	fi	
	mount $SDCARD $MNT -o uid=100000,gid=100000
else
	umount $SDCARD

	if [ $? = 0 ]; then
		rm -f $SDCARD
	else
		umount -l $MNT
		rm -f $SDCARD
	fi
fi

