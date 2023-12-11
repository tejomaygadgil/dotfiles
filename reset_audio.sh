#!/usr/bin/env bash
systemctl --user restart wireplumber pipewire pipewire-pulse
pactl load-module module-raop-discover

