# BM@bash_aliases

# Set directories
export EDITOR=nvim
export VISUAL=nvim
export WORKSPACE=~/workspace
export DOTFILES=$WORKSPACE/repo/dotfiles/
export REPO=$WORKSPACE/repo
export NOTES=$WORKSPACE/notes
export ZET="$NOTES/zet"

# https://github.com/nvm-sh/nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
nvm use stable

# https://github.com/rupa/z
. /opt/homebrew/etc/profile.d/z.sh

# Shortcut
alias dd="cd $WORKSPACE"
alias zz="cd $ZET"

# Bash
alias rc="$EDITOR ~/.bash_aliases"
alias eb='exec bash'
# http://jsomers.net/blog/dictionary
# https://luxagraf.net/src/how-use-websters-1913-dictionary-linux-edition
alias d="sdcv --color"
alias tree='tree -C'
alias t="tree -L 2"
alias tt="tree -L 3"
alias fs="du -sh */"
alias pd=pushd
alias ppd=popd
jf() { pushd `find . -name "$1" -printf '%h' -quit`; }

# Package
alias rgf="rg -F --"
alias gg='lazygit'
alias unimatrix="unimatrix -afs 90"

# nvim
alias nvu='nvim --cmd "let g:unception_disable=1"'
alias nvf='nvim $(fzf)'
alias nvz="zz; nvim 0.md"
nrg() { nvim -p `rg -lS "$@"`; }
ngm() { nvim -p `git ls-files --others --exclude-standard --modified`; }

# Tmux
alias tn='tmux'
alias tm='tmux attach'

# Scheme
alias c='clj'
alias s='rlwrap scheme'
sr () { scheme --quiet < "$1"; } # https://stackoverflow.com/a/47724861

# bash auto-completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
# tab completion if shell is interactive
if [ -t 1 ]
then
    bind 'TAB:menu-complete'
fi
