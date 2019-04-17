#!/bin/bash

# Opens a file or streaming site with MPV and slowly increases the volume.
# Set the file or site to open in wakeup-radio-file.txt, or provide a file name as argument.
# Set a crontab to specify when it should run, and keep the computer on.
# Example crontab:
#  # Wakeup radio weekdays at 7AM
#  00 07 * * 1-5 bash -l -c "/home/user/bin/wakeup-radio.sh &>/home/oubj/bin/wakeup-radio.log"
#  # Wakeup radio weekends at 9AM
#  00 09 * * 6-7 bash -l -c "/home/user/bin/wakeup-radio.sh &>/home/oubj/bin/wakeup-radio.log"

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

# Get file to read, or use default
echo
if [ $# -eq 0 ]
  then
    echo "Using default file: wakeup-radio-file.txt"
    file=wakeup-radio-file.txt
  else
    echo "Play from: $1"
    file=$1
fi

# Stream/file to play (first line)
read -r site < $file
echo
echo "Will play $site"

# Set initial volume
echo
echo "Setting volume"
pactl set-sink-volume 0 50%

# Play with mpv
echo
echo "Playing with mpv"
mpv -shuffle yes --really-quiet "$site" > /dev/null 2>&1  &

# Increase volume gradually
echo
for run in {1..50}
do
    echo "Increasing volume"
    sleep 30
    pactl set-sink-volume 0 +1%
done


echo
echo "Waiting"
sleep 7200

echo
echo "Switching off at $(date)"
