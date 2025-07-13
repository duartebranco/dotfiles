#!/bin/bash

# Function to extract album art from MP3 files
extract_album_art() {
    local file="$1"
    
    # Get the title from the MP3 metadata
    title=$(exiftool -Title -s -s -s "$file" 2>/dev/null)
    
    # If title is empty, use filename without extension and prefix
    if [ -z "$title" ]; then
        # Remove the [SPOTDOWNLOADER.COM] prefix and .mp3 extension
        title=$(basename "$file" .mp3)
        title="${title#\[SPOTDOWNLOADER.COM\] }"
    fi
    
    # Clean the title for use as filename (remove special characters)
    clean_title=$(echo "$title" | sed 's/[^a-zA-Z0-9 _-]//g' | sed 's/  */ /g' | sed 's/^ *//;s/ *$//')
    
    # Set output path
    output_path="/home/duarte/doc/Transferencias/art/${clean_title}_cover.png"
    
    # Extract album art using ffmpeg
    if ffmpeg -i "$file" -an -vcodec copy "$output_path" 2>/dev/null; then
        echo "✓ Extracted: $clean_title"
    else
        echo "✗ Failed: $clean_title (no embedded image or error)"
    fi
}

# Main execution
echo "Starting album art extraction..."
echo "Target directory: /home/duarte/doc/Transferencias/art"
echo

# Process all MP3 files in current directory
count=0
for file in *.mp3; do
    if [ -f "$file" ]; then
        extract_album_art "$file"
        ((count++))
    fi
done

echo
echo "Processed $count files."
echo "Album art saved to: /home/duarte/doc/Transferencias/art"
