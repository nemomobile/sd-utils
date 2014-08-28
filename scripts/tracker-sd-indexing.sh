#!/bin/bash
set -e
[ "$MIC_RUN" = "" ] || exit 1

gsettings set org.freedesktop.Tracker.Miner.Files index-removable-devices true
gsettings set org.freedesktop.Tracker.Miner.Files crawling-interval 0
gsettings set org.freedesktop.Tracker.Miner.Files enable-writeback false
gsettings set org.freedesktop.Tracker.Miner.Files removable-days-threshold 30
gsettings set org.freedesktop.Tracker.Miner.Files index-single-directories "['$HOME']"
gsettings set org.freedesktop.Tracker.Miner.Files index-recursive-directories "['&DESKTOP', '&DOCUMENTS', '&DOWNLOAD', '&MUSIC', '&PICTURES', '&VIDEOS', '$HOME/android_storage/DCIM', '$HOME/android_storage/Download', '$HOME/android_storage/Pictures', '$HOME/android_storage/Podcasts', '$HOME/android_storage/Music']"
gsettings set org.freedesktop.Tracker.Miner.Files ignored-directories-with-content "[ 'backup.metadata', '.nomedia' ]"
gsettings set org.freedesktop.Tracker.Miner.Files ignored-directories "[ 'po', 'CVS', 'core-dumps', 'lost+found', '$HOME/android_storage/Android' ]"
