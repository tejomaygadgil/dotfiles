#!/bin/bash

sep=' / '

# Datetime
time=$(date '+%H:%M:%S')
week=$(date '+%a %V')
date=$(date '+%m-%d-%Y')
datetime="$time $sep $date $sep $week"

# Battery level and time left
battery_dev=$(upower --enumerate | rg BAT)
level="$(upower --show-info $battery_dev | rg "percentage" | awk '{print $2}')"
time_left="$(upower --show-info $battery_dev | rg time | awk '{print $4 " " $5}')"
battery="$time_left"

# Volume
volume="$(amixer get Master | awk '$0~/%/{print $5}' | tr -d '[]%' | awk 'NR==1{print $1}')"

echo $datetime $sep $battery $sep $volume
