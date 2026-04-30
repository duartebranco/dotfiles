#!/bin/bash

# Launch sxiv in thumbnail mode and capture the selected wallpaper
WALLPAPER=$(sxiv -t -o -r ~/img/Wallpapers/)

# Check if user selected a wallpaper (sxiv returns empty if cancelled)
if [ -n "$WALLPAPER" ]; then

    wal --cols16 -i "$WALLPAPER" -n
    feh --bg-fill "$(< "${HOME}/.cache/wal/wal")" --no-fehbg

    kill -HUP $(pgrep dwm)

    "$HOME/scripts/mkXresources.sh"
    xrdb -merge "$HOME/.Xresources"
    rm "$HOME/.Xresources"

    ln -sf ~/.cache/wal/dunstrc ~/.config/dunst/dunstrc
    killall dunst
    dunst >/dev/null 2>&1 &

    [ -x "$HOME/.local/src/zed-theme-wal/generate_theme" ] && "$HOME/.local/src/zed-theme-wal/generate_theme" --mode readability

    (cd "$HOME/.local/share/starttree" && ./update.sh)

    ln -sf ~/.cache/wal/zathurarc ~/.config/zathura/zathurarc

	"$HOME/scripts/calibre.sh"

	pywalfox update

else
    exit 1
fi
