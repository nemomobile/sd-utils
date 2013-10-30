#!/bin/sh

SDCARD=/dev/sdcard
MNT=/mnt/extSdCard

if [ "$ACTION" = "add" ]
then
	chmod 755 /storage
	if [ -b /dev/mmcblk1 ]
	then
		if [ -b /dev/mmcblk1p1 ]
		then
			ln -sf /dev/mmcblk1p1 $SDCARD
		else
			ln -sf /dev/mmcblk1 $SDCARD
		fi	
	fi	
	mount $SDCARD $MNT

else
	umount $MNT

	if [ $? = 0 ]
	then
		rm -f $SDCARD
	else
		umount -l $MNT
		rm -f $SDCARD
	fi
fi

