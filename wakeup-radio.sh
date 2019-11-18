#!/bin/bash

# Opens a file or streaming site with MPV and slowly increases the volume.
# Set the file or site to open in wakeup-radio-file.txt, or provide a file name as argument.
# Set a crontab to specify when it should run, and keep the computer on.
# Example crontab:
#  # Wakeup radio weekdays at 7AM
#  00 07 * * 1-5 bash -l -c "/home/user/bin/wakeup-radio.sh &>/home/oubj/bin/wakeup-radio.log"
#  # Wakeup radio weekends at 9AM
#  00 09 * * 6-7 bash -l -c "/home/user/bin/wakeup-radio.sh &>/home/oubj/bin/wakeup-radio.log"

# Switch off function
switch_off () {
    echo
    echo "Switching off at $(date)"
    kill -15 $mpv_pid
    exit
}

echo
echo "Wake Up Radio"
echo "It is $(date)"
export XDG_RUNTIME_DIR=/run/user/1000

echo
echo "Stat"
pactl stat

echo
echo "Info"
pactl info

# Get directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo
echo "Running from $DIR"

# Get file to read, or use default
default=wakeup-radio-file.txt
echo
if [ -f "$1" ]; then
    file=$1
    echo "Found specified file"
elif [ -f "$DIR/$1" ]; then
    file=$DIR/$1
    echo "Found specified file locally"
elif [ -f "$DIR/$default" ]; then
    file=$DIR/$default
    echo "Found default file in local directory"
elif [ -f "$default" ]; then
    file=$default
    echo "Found default file"
else
    echo "No files found"
fi

# Stream/file to play (first line)
if [ -f "$file" ]; then
    read -r site < $file
else
    site=http://bbcwssc.ic.llnwd.net/stream/bbcwssc_mp1_ws-einws
    echo "Playing default: BBC World Service"
fi
echo
echo "Will play $site"

# Set initial volume
echo
echo "Setting volume"
pactl set-sink-volume 1 50%

# Play with mpv
echo
echo "Playing with mpv"
mpv -shuffle yes --really-quiet "$site" > /dev/null 2>&1  &
mpv_pid=$!

# Trap signals
trap "switch_off" 1 2 3 9 15

# Increase volume gradually
echo
for run in {1..50}
do
    echo "Increasing volume"
    sleep 30
    pactl set-sink-volume 1 +1%
done


echo
echo "Waiting"
sleep 7200

echo
echo "Switching off at $(date)"
switch_off
