#!/bin/sh

WALLPAPER=$(find ~/img/Wallpapers/ -type f | shuf -n 1)
# Set random wallpaper and its colors
wal -i "$WALLPAPER" -n
feh --bg-fill "$(< "${HOME}/.cache/wal/wal")" --no-fehbg

# testing for a specific wallpaper
# wal -i img/Wallpapers/Christ_in_the_Wilderness.png -n
# feh --bg-fill img/Wallpapers/Christ_in_the_Wilderness.png --no-fehbg

# After running wal, we must reload some things
# --------
# The dwm uses colors from Xresources in my build, and it must follow a certain sintax
# So I make my own Xresources and then merge it (with whats already created from the wal command)
[ -x "$HOME/scripts/mkXresources.sh" ] && "$HOME/scripts/mkXresources.sh"
[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"

# For dunst, i created a user template
# So now i must make dunst use the generated config
# This script already starts dunst
[ -x "$HOME/scripts/rldunst.sh" ] && "$HOME/scripts/rldunst.sh"

# Reload zed colors
[ -x "$HOME/app/zed-theme-wal/generate_theme" ] && "$HOME/app/zed-theme-wal/generate_theme" --mode readability

# Update startpage
[ -x "$HOME/scripts/update-startpage.sh" ] && "$HOME/scripts/update-startpage.sh" $WALLPAPER

# Reload pywalfox
pywalfox update
# --------

# Invert touchpad scroll
xinput set-prop 10 "libinput Natural Scrolling Enabled" 1 &

picom -b &
redshift &
exec dwm
