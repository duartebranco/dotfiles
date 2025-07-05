#!/bin/sh
#
## mkXresources.sh
#
# It creates/adds the Xresources colors portion for dwm 
# Supposed to be run after the `wal` command
input="${HOME}/.cache/wal/colors-wal-dwm.h"
output="${HOME}/.Xresources"

# Write the header
echo '! dwm' > "$output"

# List of color variables and corresponding resource names
declare -A color_map=(
    [norm_fg]="normfgcolor"
    [norm_bg]="normbgcolor"
    [norm_border]="normbordercolor"
    [sel_fg]="selfgcolor"
    [sel_bg]="selbgcolor"
    [sel_border]="selbordercolor"
)

# Variable to store selbgcolor for reuse
selbg_value=""

# Extract color values from the input file and write to output
for var in norm_fg norm_bg norm_border sel_fg sel_bg sel_border; do
    if [[ $var == "sel_border" ]]; then
        # Use the same color as selbgcolor for selbordercolor
        value="$selbg_value"
    else
        # Extract the hex color value
        value=$(grep "static const char $var" "$input" | sed -E 's/.*"#([0-9A-Fa-f]{6})".*/#\1/')
        # Store selbgcolor value for later use
        if [[ $var == "sel_bg" ]]; then
            selbg_value="$value"
        fi
    fi

    # Compose and write the resource line
    printf "dwm.%s: %s\n" "${color_map[$var]}" "$value" >> "$output"

    # Add a blank line after sel_border
    if [[ $var == "sel_border" ]]; then
        echo "" >> "$output"
    fi
done
