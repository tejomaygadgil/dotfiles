#!/bin/bash

set -e

brew install iterm2 \
  fzf \
  ripgrep \
  fd \
  tree \
  z \
  tmux \
  jesseduffield/lazygit/lazygit \
  microsoft-remote-desktop \
  redis \
  cmus \
  cava \
  coreutils \
  bash \

# MIT Scheme on M1 Mac
# https://kennethfriedman.org/thoughts/2021/mit-scheme-on-apple-silicon/
# https://linux.do/t/topic/33139/4

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
exec bash
nvm install stable

brew install \
    neovim \
    obsidian \
    --cask visual-studio-code \
    --cask rstudio \
    --cask r \
    docker \
    utm \

# Dictionary
brew install sdcv
git clone https://github.com/ahacop/websters-dict-1913-stardict.git
mkdir -p $HOME/.stardict/dic
tar -xvzf ~/Downloads/websters-dict-1913-stardict/stardict-dictd-web1913-2.4.2.tgz -C $HOME/.stardict/dic

# https://gist.github.com/xuhdev/8b1b16fb802f6870729038ce3789568f
# core
brew install coreutils
# key commands
brew install binutils \
  diffutils \
  ed \
  findutils \
  gawk \
  gnu-indent \
  gnu-sed \
  gnu-tar \
  gnu-which \
  gnutls \
  grep \
  gzip \
  screen \
  watch \
  wdiff \
  wget \
# OS X ships a GNU version, but too old
brew install bash \
  emacs \
  gpatch \
  m4 \
  make \
  nano \
  # gdb \ # gdb requires further actions to make it work. See `brew info gdb`.

brew tap d12frosted/emacs-plus
brew install emacs-plus \
  --with-imagemagick \
  --with-xwidgets \
  --with-savchenkovaleriy-big-sur-3d-icon
