#!/bin/sh
#
## mkXresources.sh
#
# It creates/adds the Xresources colors portion for dwm 
# Supposed to be run after the `wal` command
input="${HOME}/.cache/wal/colors.sh"
output="${HOME}/.Xresources"

# Source the colors file
. "$input"

# Write the header
echo '! dwm' > "$output"

# Map of color variables to Xresources names
declare -A color_map=(
    [norm_fg]="normfgcolor"
    [norm_bg]="normbgcolor"
    [norm_border]="normbordercolor"
    [sel_fg]="selfgcolor"
    [sel_bg]="selbgcolor"
    [sel_border]="selbordercolor"
)

# Define which colors from colors.sh to use for each dwm color
declare -A color_sources=(
    [norm_fg]="$color12"  # text color
    [norm_bg]="$color0"
    [norm_border]="$color8"
    [sel_fg]="$foreground"
    [sel_bg]="$color9"
    [sel_border]="$color4"
)

# Write all color definitions to output
for var in norm_fg norm_bg norm_border sel_fg sel_bg sel_border; do
    printf "dwm.%s: %s\n" "${color_map[$var]}" "${color_sources[$var]}" >> "$output"
    
    # Add a blank line after sel_border
    if [[ $var == "sel_border" ]]; then
        echo "" >> "$output"
    fi
done
