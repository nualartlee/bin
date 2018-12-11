#!/usr/bin/env bash

# Anonimize this computer
# Uses tor for all network traffic and changes mac address

# print help function
print_help()
{
    echo "              Anonimize  "
    echo
    echo "Routes all network traffic through TOR and creates a random MAC address for wlan0"
    echo
    echo "To enable, run 'anon.sh on'"
    echo "To disable, run 'anon.sh off'"
    echo
}

# Print header
clear
echo "====================================="
echo

# Run from file location
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR

# Disable anon
if [ "$1" == "off" ]; then
    echo "              De-Anonimize  "
    sudo ./toriptables2.py -f 
    sudo service network-manager stop
    sudo macchanger -p wlan0
    sudo service network-manager start

# Enable anon
elif [ "$1" == "on" ]; then
    echo "              Anonimize  "
    sudo ./toriptables2.py -l
    sudo service network-manager stop
    sudo macchanger -r wlan0
    sudo service network-manager start
else
    print_help
    exit
fi

# Show wlan0
sudo ifconfig wlan0

# Open web pages
firefox www.check-my-ip.net
firefox check.torproject.org
firefox witch.valdikss.org.ru
firefox www.doileak.com
firefox dnsleaktest.com
firefox testmyipv6.com
firefox webkay.robinlinus.com
