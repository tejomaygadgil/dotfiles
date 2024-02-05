if status is-interactive
    # Commands to run in interactive sessions can go here
    # Use latest node
    nvm use latest
    alias em='npx embedme'
    alias ems='npx embedme *.md'

    # Timer commands
    alias tt='~/workspace/git/dotfiles/scripts/timer.sh'
    alias tk='kill "$(pgrep timer)"'

    # Clear startup message
    set -g fish_greeting

    # Change default directory
    alias dd='cd /home/tejomay/workspace'
    # dd

    # Apps
    alias nv='nvim'
    alias tn='tmux'
    alias tm='tmux attach'
    alias mr='~/workspace/git/micro-rest/micro-rest.sh'
    alias wo='cd /home/tejomay/workspace/notes/wozu/; python server.py'
    alias rb='~/workspace/git/dotfiles/scripts/reset_audio.sh'
    alias gg='lazygit'

    # Configs
    alias fs='nvim ~/workspace/git/dotfiles/config/config.fish'
    alias sf='source ~/workspace/git/dotfiles/config/config.fish'

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

