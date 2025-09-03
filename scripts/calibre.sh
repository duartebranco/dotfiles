#!/bin/bash

# Paths to the files
WAL_CACHE="$HOME/.cache/wal/calibregui"
CALIBRE_CONFIG="$HOME/.config/calibre/gui.json"

# Check if the wal cache file exists
if [ ! -f "$WAL_CACHE" ]; then
    echo "Error: $WAL_CACHE not found!"
    exit 1
fi

# Check if the calibre config file exists
if [ ! -f "$CALIBRE_CONFIG" ]; then
    echo "Error: $CALIBRE_CONFIG not found!"
    exit 1
fi

# Create a temporary file for processing
TMP_FILE=$(mktemp)

# Extract the color values from wal cache
declare -A COLORS
while IFS=":" read -r key value; do
    # Clean up the key and value
    key=$(echo "$key" | tr -d '[:space:]"' | sed 's/-/_/g')
    value=$(echo "$value" | tr -d '[:space:],"' | sed 's/-/_/g')

    # Skip empty or malformed lines
    if [[ -z "$key" || -z "$value" ]]; then
        continue
    fi

    COLORS["$key"]="$value"
done < "$WAL_CACHE"

# Process the calibre config file
jq --argjson colors "$(
    printf '%s\n' '{
        "AlternateBase": "'"${COLORS[AlternateBase]}"'",
        "Base": "'"${COLORS[Base]}"'",
        "BrightText": "'"${COLORS[BrightText]}"'",
        "BrightText_disabled": "'"${COLORS[BrightText_disabled]}"'",
        "Button": "'"${COLORS[Button]}"'",
        "ButtonText": "'"${COLORS[ButtonText]}"'",
        "ButtonText_disabled": "'"${COLORS[ButtonText_disabled]}"'",
        "Highlight": "'"${COLORS[Highlight]}"'",
        "HighlightedText": "'"${COLORS[HighlightedText]}"'",
        "HighlightedText_disabled": "'"${COLORS[HighlightedText_disabled]}"'",
        "Link": "'"${COLORS[Link]}"'",
        "LinkVisited": "'"${COLORS[LinkVisited]}"'",
        "PlaceholderText": "'"${COLORS[PlaceholderText]}"'",
        "PlaceholderText_disabled": "'"${COLORS[PlaceholderText_disabled]}"'",
        "Text": "'"${COLORS[Text]}"'",
        "Text_disabled": "'"${COLORS[Text_disabled]}"'",
        "ToolTipBase": "'"${COLORS[ToolTipBase]}"'",
        "ToolTipText": "'"${COLORS[ToolTipText]}"'",
        "ToolTipText_disabled": "'"${COLORS[ToolTipText_disabled]}"'",
        "Window": "'"${COLORS[Window]}"'",
        "WindowText": "'"${COLORS[WindowText]}"'",
        "WindowText_disabled": "'"${COLORS[WindowText_disabled]}"'"
    }' | jq -c .
)" '.dark_palettes.__current__ = $colors' "$CALIBRE_CONFIG" > "$TMP_FILE"

# Replace the original file with the updated one
mv "$TMP_FILE" "$CALIBRE_CONFIG"

echo "Calibre GUI colors updated successfully!"
