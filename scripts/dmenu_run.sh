#!/bin/sh
# Import the colors
. "${HOME}/.cache/wal/colors.sh"

# Call original dmenu_run with colors + any additional args
exec /usr/bin/dmenu_run -nb "$color0" -nf "$color15" -sb "$color1" -sf "$color15" "$@"

