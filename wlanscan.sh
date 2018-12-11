#!/usr/bin/env bash

sudo iw wlan0 scan | egrep "^((BSS)|(.{1,10}signal)|(.{1,10}SSID))"
echo "To connect:"
echo "sudo iw wlan0 connect SSID BSSID"
