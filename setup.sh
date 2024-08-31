#!/bin/bash

set -e

brew install fzf ripgrep fd tree z jesseduffield/lazygit/lazygit tmux coreutils nvm neovim cmus rlwrap emacs

# MIT Scheme on M1 Mac
# https://kennethfriedman.org/thoughts/2021/mit-scheme-on-apple-silicon/
# https://linux.do/t/topic/33139/4

# Dictionary
brew install sdcv
git clone https://github.com/ahacop/websters-dict-1913-stardict.git
mkdir -p $HOME/.stardict/dic
tar -xvzf ~/Downloads/websters-dict-1913-stardict/stardict-dictd-web1913-2.4.2.tgz -C $HOME/.stardict/dic
