#!/usr/bin/env bash
# https://support.system76.com/articles/audio/
systemctl --user restart wireplumber pipewire pipewire-pulse
rm -r ~/.config/pulse
# Airplay
pactl load-module module-raop-discover

# cf. https://askubuntu.com/a/1030961 for BT connection issues

