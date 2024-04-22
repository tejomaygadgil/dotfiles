#!/bin/bash

sep_start=''
sep_end=''
sep=→

# Date / time
dow=`date '+%a'`
week=`date '+%V'`
date=`date '+%Y-%m-%d'`
time=`date '+%H:%M:%S'`

# Battery
battery_dev=`upower --enumerate | rg BAT`
time_left=`upower --show-info $battery_dev | rg time | awk '{print $4 " " $5}'`
bat=`upower --show-info $battery_dev | rg "percentage" | awk '{print $2}'`

# Volume
vol="$(amixer get Master | awk '$0~/%/{print $5}' | tr -d '[]%' | awk 'NR==1{print $1}')%"

# Wifi
wifi="nmcli | grep 'wlp58s0: connected' | cut -d' ' -f4-"

# Brightness
. ~/.config/sway/brightness.sh
brightness=$(echo "`get_brightness` / $MAX_BRIGHTNESS * 100" | bc -l | awk '{printf "%.f", $1}')%

echo -e vol $vol $sep bat $bat $sep bts $brightness $sep $dow $time $sep $date
