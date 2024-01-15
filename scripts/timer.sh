#!/bin/bash

# Run in background
if [ "$1" != "--running" ]; then
  $0 --running &
  disown
  exit
fi

# https://superuser.com/a/611582
start=$(date +%s)
while true; do
    time="$(($(date +%s) - $start))"
    printf '%s' "$(date -u -d "@$time" +%H:%M:%S)" > ~/time.txt
    sleep 1  # Adding a sleep to reduce the write frequency
done
