#!/usr/bin/env bash

# Installs tmux with sixel support.
# Modifed from https://gist.github.com/nanmu42/97e7d476bbd89301fc74ed23eb0cd65a

# Exit immediately with any errors
set -e

# Dependencies
apt update
apt install -y git automake build-essential pkg-config libevent-dev libncurses5-dev byacc

# Clone tmux repository
rm -rf /tmp/tmux
git clone https://github.com/tmux/tmux.git /tmp/tmux
cd /tmp/tmux

# Install using sixel option
# Cf. https://www.arewesixelyet.com/#tmux
bash autogen.sh
./configure --enable-sixel && make
make install
cd -

# Clean up
rm -rf /tmp/tmux
