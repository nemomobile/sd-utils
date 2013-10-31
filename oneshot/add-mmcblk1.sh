#!/bin/bash

if [ "$(grep extSdCard /etc/fstab)" == "" ]
then
	echo "/dev/sdcard /run/user/100000/media/sdcard auto rw,noauto,nosuid,nodev,users,umask=0000,sync 0 0" >> /etc/fstab
fi
