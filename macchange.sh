#!/usr/bin/env bash

sudo service network-manager stop
sudo macchanger -r wlan0
sudo service network-manager start
sudo ifconfig

