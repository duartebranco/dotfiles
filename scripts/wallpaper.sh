#!/bin/bash

# Launch sxiv in thumbnail mode and capture the selected wallpaper
WALLPAPER=$(sxiv -t -o ~/img/Wallpapers/)

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

	[ -x "$HOME/app/zed-theme-wal/generate_theme" ] && "$HOME/app/zed-theme-wal/generate_theme" --mode readability

    (cd "$HOME/app/startpage" && ./update-startpage.sh)

    ln -sf ~/.cache/wal/zathurarc ~/.config/zathura/zathurarc

	"$HOME/scripts/calibre.sh"

	pywalfox update

else
    exit 1
fi
