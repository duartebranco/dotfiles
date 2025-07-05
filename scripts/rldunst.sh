#!/bin/sh

ln -sf ~/.cache/wal/dunstrc ~/.config/dunst/dunstrc

killall dunst
dunst >/dev/null 2>&1 &

