#!/bin/bash

set -e

for file in `find $PWD/home -type f`; do ln -sf "$file" ~/; done
ln -sf $PWD/.ignore ~/workspace/
ln -sf $PWD/nvim/ ~/.config/
