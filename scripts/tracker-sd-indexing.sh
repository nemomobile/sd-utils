#!/bin/bash

if [ -b /dev/sdcard  ]
then
	gsettings set org.freedesktop.Tracker.Miner.Files index-removable-devices true
	gsettings set org.freedesktop.Tracker.Miner.Files index-recursive-directories "['&DESKTOP', '&DOCUMENTS', '&DOWNLOAD', '&MUSIC', '&PICTURES', '&VIDEOS', '/storage/extSdCard']"
else
	gsettings set org.freedesktop.Tracker.Miner.Files index-removable-devices false	
fi

systemctl --user restart tracker-miner-fs.service

