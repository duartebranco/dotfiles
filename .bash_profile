#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# auto-startx
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
	exec startx
fi

