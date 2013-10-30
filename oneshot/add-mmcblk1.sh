#!/bin/bash

if [ "$(grep extSdCard /etc/fstab)" == "" ]
then
	echo "/dev/mmcblk1p1 /storage/extSdCard auto rw,noauto,nosuid,nodev,users,umask=0000,sync 0 0" >> /etc/fstab
fi
