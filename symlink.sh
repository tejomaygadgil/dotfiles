#!/bin/bash

set -e

for file in `find ./config/home/ -type f`; do ln -rsf "$file" ~/; done
ln -rsf ./config/.ignore ~/workspace/
ln -rsf ./config/firefox/chrome/ ~/.mozilla/firefox/e4xc206r.default-release/
ln -rsf ./nvim/ ~/.config/
ln -rsf ./config/sway/ ~/.config/
ln -rsf ./config/pipewire/ ~/.config/
ln -rsf ./config/foot.ini ~/.config/foot/
ln -rsf ./config/config.fish ~/.config/fish/
ln -rsf ./config/alacritty.yml ~/.config/alacritty/
