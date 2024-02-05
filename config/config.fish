if status is-interactive
    # Commands to run in interactive sessions can go here

    # Clear startup message
    set -g fish_greeting

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

