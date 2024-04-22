#!/bin/bash

set -e

# Set brightness permissions:
# https://github.com/Hummer12007/brightnessctl/issues/63#issuecomment-788909730
PERCENT_CHANGE=0.05
BRIGHTNESS_DIR=/sys/class/backlight/intel_backlight
MAX_BRIGHTNESS=`cat $BRIGHTNESS_DIR/max_brightness`
BRIGHTNESS_UNIT=`echo "$PERCENT_CHANGE * $MAX_BRIGHTNESS" | bc -l`
get_brightness() { cat "$BRIGHTNESS_DIR/brightness"; }
mod_brightness() {
  new_brightness=$(echo "`get_brightness` $1 $BRIGHTNESS_UNIT" | bc -l | awk '{printf "%.f", $1}')
  echo $new_brightness > /sys/class/backlight/intel_backlight/brightness
}
