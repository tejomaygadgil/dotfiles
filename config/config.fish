if status is-interactive
    # Commands to run in interactive sessions can go here

    # Clear startup message
    set -g fish_greeting
    
    # Change default directory
    alias dd='cd /home/tejomay/workspace'
    dd

    # Apps
    alias tm='tmux attach'
    alias tma='tmux attach'
    alias tmm='tmux'
    alias td='termdown --no-figlet'
    alias mr='~/workspace/git/micro-rest/micro-rest.sh'
    alias wo='cd /home/tejomay/workspace/notes/wozu/; python server.py'
    alias rb='~/workspace/git/dotfiles/reset_audio.sh'
    alias gg='lazygit'

    # Configs
    alias fs='nvim ~/workspace/git/dotfiles/config/config.fish'
    alias sf='source ~/workspace/git/dotfiles/config/config.fish'

    # Directories
    alias no='cd /home/tejomay/workspace/notes'
    alias sicp='cd /home/tejomay/workspace/notes/swe/sicp'
    alias dot='cd /home/tejomay/workspace/git/dotfiles'

end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/tejomay/anaconda3/bin/conda
    # Broken pipe fix as per https://github.com/IlanCosman/tide/issues/143
    status is-interactive && eval /home/tejomay/anaconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/tejomay/anaconda3/etc/fish/conf.d/conda.fish"
        . "/home/tejomay/anaconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/tejomay/anaconda3/bin" $PATH
    end
end
# <<< conda initialize <<<

