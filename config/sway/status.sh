#!/bin/bash

sep_start=''
sep_end=''
sep='~'

# Date / time
dow=`date '+%a'`
week=`date '+%V'`
date=`date '+%-m/%d/%Y'`
time=`date '+%H:%M:%S'`

# Battery
battery_dev=`upower --enumerate | rg BAT`
level=`upower --show-info $battery_dev | rg "percentage" | awk '{print $2}'`
time_left=`upower --show-info $battery_dev | rg time | awk '{print $4 " " $5}'`

bat="bat $level"

# Volume
vol="vol $(amixer get Master | awk '$0~/%/{print $5}' | tr -d '[]%' | awk 'NR==1{print $1}')%"

echo $date $sep $vol $sep $bat $sep $dow $time
