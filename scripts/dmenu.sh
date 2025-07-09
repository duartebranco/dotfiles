#!/bin/sh
# Import the colors
. "${HOME}/.cache/wal/colors.sh"

# Call original dmenu with colors + any additional args
exec /usr/local/bin/dmenu -bw 3 -nb "$color0" -nf "$color12" -sb "$color4" -sf "$color15" "$@"
 
