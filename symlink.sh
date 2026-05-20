#!/bin/bash

set -e

for file in `find $PWD/home -type f`; do ln -sf "$file" ~/; done
ln -sf $PWD/.ignore ~/workspace/
ln -sf $PWD/nvim/ ~/.config/
ln -sf $PWD/emacs/init.el ~/.emacs.d/init.el
ln -sf $PWD/emacs/early-init.el ~/.emacs.d/early-init.el
cp -f $PWD/scripts/com.local.KeyRemapping.plist ~/Library/LaunchAgents/
mkdir -p ~/Library/KeyBindings/
cp -f $PWD/home/DefaultKeyBinding.dict ~/Library/KeyBindings/
