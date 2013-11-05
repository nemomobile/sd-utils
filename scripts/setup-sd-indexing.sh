#!/bin/bash

DEF_UID=$(grep "^UID_MIN" /etc/login.defs |  tr -s " " | cut -d " " -f2)

if [ "$(gsettings get org.freedesktop.Tracker.Miner.Files index-recursive-directories | grep extSdCard)" != ""  ]; then
	echo "you have older version already installed, patching config files."
	if [ -b /dev/sdcard ]; then
		gsettings set org.freedesktop.Tracker.Miner.Files index-recursive-directories "['&DESKTOP', '&DOCUMENTS', '&DOWNLOAD', '&MUSIC', '&PICTURES', '&VIDEOS', '/run/user/$DEF_UID/media/sdcard']"
	else
		gsettings set org.freedesktop.Tracker.Miner.Files index-recursive-directories "['&DESKTOP', '&DOCUMENTS', '&DOWNLOAD', '&MUSIC', '&PICTURES', '&VIDEOS']"
	fi
fi
