# BM@aliases-head
export EDITOR=nvim
export VISUAL=nvim
export WORKSPACE=~/workspace
export DOTFILES=$WORKSPACE/git/dotfiles/
export SCRIPTS="$DOTFILES/scripts"
export NOTES=$WORKSPACE/notes
export ZET="$NOTES/zet"
# Spark
export PYSPARK_DRIVER_PYTHON=ipython

# Config
alias wifi='nmtui'
alias sound='wpctl status'
alias bluetooth='bluetoothctl'
alias sinks='pactl list short sinks'
alias set-sink='pactl set-default-sink'
change_sink() { set-sink `sinks | rg $1 | cut -d$'\t' -f1`; }
alias s1="change_sink pci" # Laptop speakers
alias s2="change_sink UMC404HD" # Audio interface
alias s3="change_sink raop" # OD-11
alias s4="change_sink E34m_G4" # Monitor speaker
alias s5="change_sink bluez" # Bluetooth

# Bash
alias rc="$EDITOR $DOTFILES/config/home/.bash_aliases"
alias eb='exec bash'
# Cd aliases
alias dd="cd $WORKSPACE"
alias zz="cd $ZET"
# Bash aliases
alias t="tree -L 2"
alias tt="tree -L 3"
alias pd=pushd
alias ppd=popd
jf() { pushd `find . -name "$1" -printf '%h' -quit`; }
# Nvim
alias nv='nvim --cmd "let g:unception_disable=1"'
alias nu=nvim
alias nf='nvim $(fzf)'
alias nz="zz; nvim 0.md"
nrg() { nvim -p `rg -lS "$@"`; }
ngm() { nvim -p `git ls-files --others --exclude-standard --modified`; }
# Zet
alias em='npx embedme'
alias ems='npx embedme *.md'
# Tmux
alias tn='tmux'
alias tm='tmux attach'
# Misc
alias gg='lazygit'
alias i2s='img2sixel'
alias info="info --vi-keys"
alias unimatrix="unimatrix -afs 90"
alias s='rlwrap scheme'
sr () { scheme --quiet < "$1"; } # https://stackoverflow.com/a/47724861
# Apps
alias mr='~/workspace/git/micro-rest/micro-rest.sh'
alias wo='cd /home/tejomay/workspace/notes/wozu/; python server.py'
alias rb="$SCRIPTS/reset_audio.sh"
# Dictionary
# http://jsomers.net/blog/dictionary
# https://luxagraf.net/src/how-use-websters-1913-dictionary-linux-edition 
alias d="sdcv --color"
wt() { open "https://en.wiktionary.org/w/index.php?search=$@"; }
# Timer
alias timer="$SCRIPTS/timer.sh"
alias tk='kill "$(pgrep timer)"'

# https://github.com/nvm-sh/nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
nvm use stable
# https://github.com/rupa/zo
. /etc/profile.d/z.sh
# bash auto-completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
 
if [ -t 1 ]
then
    bind 'TAB:menu-complete'
fi
# fzf ctrl+r 
source /usr/share/doc/fzf/examples/key-bindings.bash

