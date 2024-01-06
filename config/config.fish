if status is-interactive
    # Commands to run in interactive sessions can go here

    # Clear startup message
    set -g fish_greeting
    
    # Change default directory
    alias dd='cd /home/tejomay/workspace'
    dd

    # Apps
    alias mr='~/workspace/git/micro-rest/micro-rest.sh'
    alias wo='cd /home/tejomay/workspace/notes/wozu/; python server.py'
    alias rb='~/workspace/git/dotfiles/reset_audio.sh'
    alias gg='lazygit'

    # Configs
    alias fs='nvim /home/tejomay/config.fish'

    # Directories
    alias no='cd /home/tejomay/workspace/notes'
    alias sicp='cd /home/tejomay/workspace/notes/swe/sicp'
    alias dot='cd /home/tejomay/workspace/git/dotfiles'

end
