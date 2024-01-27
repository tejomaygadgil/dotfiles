#!/bin/bash

sep=' / '

# Datetime
time=$(date '+%H:%M:%S')
date=$(date '+%a %m-%d-%Y')
datetime="$time $sep $date"

# Battery level and time left
battery_dev=$(upower --enumerate | rg BAT)
level="$(upower --show-info $battery_dev | rg "percentage" | awk '{print $2}')"
time_left="$(upower --show-info $battery_dev | rg time | awk '{print $4 " " $5}')"
battery="$time_left"

echo $datetime $sep $battery
