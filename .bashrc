#
# ~/.bashrc
#

# Quick home cleanup
# (even works in non-interactive mode)
rm -rf ~/.vscode ~/.stremio-server ~/.pki ~/.m2 ~/.dotnet ~/.java ~/.skiko ~/.rustup ~/.lemminx ~/.sts4 ~/.emulator_console_auth_token ~/.eclipse ~/.sonar ~/.mozilla ~/.ipython ~/.anaconda ~/.conda ~/.condarc ~/.bun ~/.jupyter ~/.mongodb ~/.opencode ~/.cassandra ~/.android ~/.copilot

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH="$HOME/.local/bin:$PATH"

export ANDROID_SDK_ROOT="/home/duarte/.local/share/android-sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export ANDROID_AVD_HOME="$HOME/doc/Vms/avd"
export ANDROID_EMULATOR_HOME="$XDG_CONFIG_HOME/android"
export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator:$PATH"

XDG_CONFIG_HOME=/home/duarte/.config
XDG_CACHE_HOME=/home/duarte/.cache
XDG_STATE_HOME=/home/duarte/.local/state
XDG_DATA_HOME=/home/duarte/.local/share
XDG_BIN_DIR="$HOME/.local/bin"

# claude
export CLAUDE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/claude"

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
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias dotfiles='/usr/bin/git --git-dir=$XDG_DATA_HOME/dotfiles/ --work-tree=$HOME'
alias code='code --extensions-dir "$XDG_DATA_HOME/vscode"'
alias nc='ncat'

# exports (for clean up $HOME)
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export HISTFILE="$XDG_STATE_HOME/bash/history"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
export W3M_DIR="$XDG_CONFIG_HOME/w3m"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
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

