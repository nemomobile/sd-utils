#!/bin/bash

SDCARD=/dev/sdcard
DEF_UID=$(grep "^UID_MIN" /etc/login.defs |  tr -s " " | cut -d " " -f2)
DEF_GID=$(grep "^GID_MIN" /etc/login.defs |  tr -s " " | cut -d " " -f2)
DEVICEUSER=$(getent passwd $DEF_UID | sed 's/:.*//')
MNT=/run/user/$DEF_UID/media/sdcard

if [ "$ACTION" = "add" ]; then
	if [ -b /dev/mmcblk1p1 ]; then
		ln -sf /dev/mmcblk1p1 $SDCARD
	elif [ -b /dev/mmcblk1 ]; then
		ln -sf /dev/mmcblk1 $SDCARD
	else
		exit $?
	fi
	su $DEVICEUSER -c "mkdir -p $MNT"
	case "${ID_FS_TYPE}" in
		vfat|ntfs|exfat)
			mount $SDCARD $MNT -o uid=$DEF_UID,gid=$DEF_GID,sync
			;;
		*)
			if [ ! -z "${ID_FS_TYPE}" ]; then
				mount $SDCARD $MNT -o sync
				chown $DEF_UID:$DEF_GID $MNT
			fi
			;;
	esac
else
	umount $SDCARD

	if [ $? = 0 ]; then
		rm -f $SDCARD
	else
		umount -l $MNT
		rm -f $SDCARD
	fi
fi

