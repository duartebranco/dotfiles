#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

XDG_CONFIG_HOME=/home/duarte/.config
XDG_CACHE_HOME=/home/duarte/.cache
XDG_STATE_HOME=/home/duarte/.local/state
XDG_DATA_HOME=/home/duarte/.local/share

# Source pywal colors
[ -f "$HOME/.cache/wal/colors.sh" ] && source "$HOME/.cache/wal/colors.sh"

# Define ANSI escape code from hex
hex_to_ansi() {
    local hex=${1#"#"}
    printf "\[\e[38;2;%d;%d;%dm\]" 0x${hex:0:2} 0x${hex:2:2} 0x${hex:4:2}
}

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# my aliases
alias ll='ls -la'
alias dmenu='/home/duarte/scripts/dmenu.sh'
alias dmenu_run='/home/duarte/scripts/dmenu_run.sh'
alias firefox='/home/duarte/scripts/firefox.sh'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias dotfiles='/usr/bin/git --git-dir=$HOME/app/dotfiles/ --work-tree=$HOME'

# exports (for clean up $HOME)
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export HISTFILE="$XDG_STATE_HOME/bash/history"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
export W3M_DIR="$XDG_CONFIG_HOME/w3m"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" 
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
# Uncomment if you need to have a wgetrc
# export WGETRC="$XDG_CONFIG_HOME/wgetrc" 

# Build PS1 with pywal colors
COLOR_USER=$(hex_to_ansi "$color12")
COLOR_PATH=$(hex_to_ansi "$color14")
COLOR_GIT=$(hex_to_ansi "$color1")
COLOR_RESET='\[\e[0m\]'


parse_git_branch() {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ] && [ "$branch" != "HEAD" ]; then
        echo " (🌱$branch)"
    fi
}

PS1="[${COLOR_USER}\u@\h ${COLOR_PATH}\w\$(parse_git_branch)${COLOR_RESET}]\$ "
# PS1='[\u@\h \W]\$ '

