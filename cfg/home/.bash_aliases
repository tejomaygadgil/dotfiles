# Color aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alhF'
alias la='ls -a'
alias l='ls -CF'
alias tree='tree -C'


# BM@aliases-head
export EDITOR=nvim
export VISUAL=nvim
export WORKSPACE=~/workspace
export DOTFILES=$WORKSPACE/repo/dotfiles/
export SCRIPTS="$DOTFILES/scripts"
export NOTES=$WORKSPACE/notes
export ZET="$NOTES/zet"

# Bash
alias rc="$EDITOR $DOTFILES/cfg/home/.bash_aliases"
alias eb='exec bash'
# Cd aliases
alias dd="cd $WORKSPACE"
alias zz="cd $ZET"
# Bash aliases
alias t="tree -L 2"
alias tt="tree -L 3"
alias pd=pushd
alias ppd=popd
# Nvim
alias nf='nvim $(fzf)'
alias nz="zz; nvim 0.md"
nrg() { nvim -p `rg -lS "$@"`; }
ngm() { nvim -p `git ls-files --others --exclude-standard --modified`; }
# Tmux
alias tn='tmux'
alias tm='tmux attach'
# Misc
alias gg='lazygit'
alias info="info --vi-keys"
alias unimatrix="unimatrix -afs 90"
alias s='rlwrap scheme'
sr () { scheme --quiet < "$1"; } # https://stackoverflow.com/a/47724861
# Dictionary
# http://jsomers.net/blog/dictionary
# https://luxagraf.net/src/how-use-websters-1913-dictionary-linux-edition 
alias d="sdcv --color"
wt() { open "https://en.wiktionary.org/w/index.php?search=$@"; }

# https://github.com/nvm-sh/nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
nvm use stable
# https://github.com/rupa/zo
. /opt/homebrew/etc/profile.d/z.sh
