#!/bin/bash

set -e

for file in `find ./cfg/home/ -type f`; do ln -rsf "$file" ~/; done
ln -rsf ./cfg/.ignore ~/workspace/
ln -rsf ./cfg/nvim/ ~/.config/
ln -rsf ./cfg/foot/ ~/.config/
ln -rsf ./cfg/sway/ ~/.config/
ln -rsf ./cfg/pipewire/ ~/.config/
ln -rsf ./cfg/config.fish ~/.config/fish/
ln -rsf ./cfg/alacritty.yml ~/.config/alacritty/
