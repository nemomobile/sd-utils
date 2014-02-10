#!/bin/bash

gsettings set org.freedesktop.Tracker.Miner.Files index-removable-devices true
 
if [ "$(gsettings get org.freedesktop.Tracker.Miner.Files index-recursive-directories | grep extSdCard)" = "" ]
then
    gsettings set org.freedesktop.Tracker.Miner.Files index-recursive-directories "['&DESKTOP', '&DOCUMENTS', '&DOWNLOAD', '&MUSIC', '&PICTURES', '&VIDEOS', '/media/sdcard']"
fi

