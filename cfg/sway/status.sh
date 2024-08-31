#!/bin/bash

sep_start=''
sep_end=''
sep=→

# Date / time
dow=`date '+%a'`
week=`date '+%V'`
date=`date '+%m-%d-%Y'`
time=`date '+%H:%M:%S'`

# Battery
time_left=`pmset -g batt | tail -n 1 | tr '[:space:]' ';' | cut -d ';' -f 8`
bat=`pmset -g batt | tail -n 1 | tr '[:space:]' ';' | cut -d ';' -f 4`
# Volume
vol=`osascript -e 'output volume of (get volume settings)'`%

echo -e vol $vol $sep bat $bat $sep $dow $time $sep $date
