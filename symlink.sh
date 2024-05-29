#!/bin/bash

set -e

for file in `find $PWD/cfg/home -type f`; do ln -sf "$file" ~/; done
ln -sf $PWD/cfg/.ignore ~/workspace/
ln -sf $PWD/cfg/nvim/ ~/.config/
