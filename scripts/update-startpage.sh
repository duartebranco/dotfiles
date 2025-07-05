#!/bin/bash
WALLPAPER_PATH="$1"
EXTENSION="${WALLPAPER_PATH##*.}"

cp ~/.cache/wal/colors.css ~/app/startpage/src/theme/colors.css

rm ~/app/startpage/src/theme/wallpaper*
cp "$WALLPAPER_PATH" ~/app/startpage/src/theme/wallpaper.${EXTENSION}

