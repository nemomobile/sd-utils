#!/bin/bash

if [ -b /dev/sdcard  ]
then
	if [ "$(gsettings get org.freedesktop.Tracker.Miner.Files index-removable-devices)" = "false" ]
	then
		gsettings set org.freedesktop.Tracker.Miner.Files index-removable-devices true
	fi

	if [ "$(gsettings get org.freedesktop.Tracker.Miner.Files index-recursive-directories | grep extSdCard)" = "" ]
	then
		gsettings set org.freedesktop.Tracker.Miner.Files index-recursive-directories "['&DESKTOP', '&DOCUMENTS', '&DOWNLOAD', '&MUSIC', '&PICTURES', '&VIDEOS', '/run/user/100000/media/sdcard']"
	fi
fi

systemctl --user restart tracker-miner-fs.service

