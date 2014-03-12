#!/bin/bash

gsettings set org.freedesktop.Tracker.Miner.Files index-removable-devices true
gsettings set org.freedesktop.Tracker.Miner.Files crawling-interval 0
gsettings set org.freedesktop.Tracker.Miner.Files enable-writeback false
gsettings set org.freedesktop.Tracker.Miner.Files removable-days-threshold 30
gsettings set org.freedesktop.Tracker.Miner.Files index-single-directories "['$HOME']"
gsettings set org.freedesktop.Tracker.Miner.Files index-recursive-directories "['&DESKTOP', '&DOCUMENTS', '&DOWNLOAD', '&MUSIC', '&PICTURES', '&VIDEOS']"
