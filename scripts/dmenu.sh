#!/bin/sh
# Import the colors
. "${HOME}/.cache/wal/colors.sh"

# Call original dmenu with colors + any additional args
exec /usr/local/bin/dmenu -nb "$color0" -nf "$color15" -sb "$color1" -sf "$color15" "$@"
 
