# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000


export BASH_SILENCE_DEPRECATION_WARNING=1

force_color_prompt=yes
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
unset force_color_prompt
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alhF'
alias la='ls -a'
alias l='ls -CF'
alias tree='tree -C'

source ~/.bash_aliases

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(fzf --bash)"
export PATH="/opt/homebrew/opt/m4/bin:$PATH"
