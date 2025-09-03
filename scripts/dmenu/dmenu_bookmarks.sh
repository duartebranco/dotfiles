#!/bin/bash

# Bookmark manager script for dmenu

BOOKMARK_FILE="$HOME/app/duarte/startpage/bookmarks.html"

# Check if bookmark file exists
if [ ! -f "$BOOKMARK_FILE" ]; then
    echo "Error: Bookmark file not found at $BOOKMARK_FILE"
    exit 1
fi

# Function to get all h2 sections from the HTML file
get_sections() {
    grep -oP '<h2>\K[^<]*(?=</h2>)' "$BOOKMARK_FILE" 2>/dev/null || \
    grep -o '<h2>[^<]*</h2>' "$BOOKMARK_FILE" | sed 's/<h2>//g' | sed 's/<\/h2>//g'
}

add_bookmark() {
    local section="$1"
    local url="$2"
    local text="$3"

    # Show what section we're looking for in the HTML
    grep -n -A 5 -B 1 "<h2>$section</h2>" "$BOOKMARK_FILE" >&2

    # Escape special characters for sed
    local escaped_section=$(echo "$section" | sed 's/[[\.*^$()+?{|]/\\&/g')
    local escaped_url=$(echo "$url" | sed 's/[\/&]/\\&/g')
    local escaped_text=$(echo "$text" | sed 's/[\/&]/\\&/g')


    # Let's try a simpler approach - find the line number of the section
    section_line=$(grep -n "<h2>$section</h2>" "$BOOKMARK_FILE" | cut -d: -f1)

    if [ -z "$section_line" ]; then
        grep -n "<h2>" "$BOOKMARK_FILE" >&2
        return 1
    fi

    # Find the next </ul> after the section
    closing_ul_line=$(tail -n +$((section_line + 1)) "$BOOKMARK_FILE" | grep -n "</ul>" | head -1 | cut -d: -f1)
    if [ -n "$closing_ul_line" ]; then
        closing_ul_line=$((section_line + closing_ul_line))
    else
        return 1
    fi

    # Insert the bookmark before the closing </ul>
    sed -i "${closing_ul_line}i\\
\\t\\t\\t\\t<li><a href=\"$escaped_url\">$escaped_text</a></li>" "$BOOKMARK_FILE"

    echo "Added bookmark '$text' to section '$section'"
}



# Function to get bookmarks from a specific section
get_bookmarks_from_section() {
    local section="$1"
    local escaped_section=$(echo "$section" | sed 's/[[\.*^$()+?{|]/\\&/g')

    # Extract bookmarks from the specific section
    awk "/<h2>$escaped_section<\/h2>/,/<\/ul>/" "$BOOKMARK_FILE" | \
    grep -o '<a href="[^"]*">[^<]*</a>' | \
    sed 's/<a href="[^"]*">//g' | \
    sed 's/<\/a>//g'
}

# Function to remove a bookmark
remove_bookmark() {
    local section="$1"
    local bookmark_text="$2"

    local escaped_section=$(echo "$section" | sed 's/[[\.*^$()+?{|]/\\&/g')
    local escaped_text=$(echo "$bookmark_text" | sed 's/[[\.*^$()+?{|]/\\&/g')

    # Remove the bookmark line
    sed -i "/<h2>$escaped_section<\/h2>/,/<\/ul>/ {
        /<a href=\"[^\"]*\">$escaped_text<\/a>/ {
            N
            d
        }
    }" "$BOOKMARK_FILE"

    # Also try to remove just the li containing the bookmark
    sed -i "/<h2>$escaped_section<\/h2>/,/<\/ul>/ {
        /<li><a href=\"[^\"]*\">$escaped_text<\/a><\/li>/d
    }" "$BOOKMARK_FILE"

    echo "Removed bookmark '$bookmark_text' from section '$section'"
}

# Main script logic
main() {
    # Ask for action (add or remove)
    ACTION=$(echo -e "Add\nRemove" | ~/scripts/dmenu.sh -l 2 -p "Bookmarks Mng:")

    if [ -z "$ACTION" ]; then
        echo "No action selected. Exiting."
        exit 0
    fi

    # Get available sections
    SECTIONS=$(get_sections)

    if [ -z "$SECTIONS" ]; then
        echo "No sections found in bookmark file."
        exit 1
    fi

    # Ask for section
    SECTION=$(echo "$SECTIONS" | ~/scripts/dmenu.sh -l 10 -p "Select section:")

    if [ -z "$SECTION" ]; then
        echo "No section selected. Exiting."
        exit 0
    fi

    if [ "$ACTION" = "Add" ]; then
        # Ask for URL
        URL=$(echo "" | ~/scripts/dmenu.sh -p "Enter URL:")

        if [ -z "$URL" ]; then
            echo "No URL entered. Exiting."
            exit 0
        fi

        # Ask for link text
        TEXT=$(echo "" | ~/scripts/dmenu.sh -p "Enter link text:")

        if [ -z "$TEXT" ]; then
            echo "No link text entered. Exiting."
            exit 0
        fi

        # Add the bookmark
        add_bookmark "$SECTION" "$URL" "$TEXT"

    elif [ "$ACTION" = "Remove" ]; then
        # Get bookmarks from the selected section
        BOOKMARKS=$(get_bookmarks_from_section "$SECTION")

        if [ -z "$BOOKMARKS" ]; then
            echo "No bookmarks found in section '$SECTION'."
            exit 1
        fi

        # Ask which bookmark to remove
        BOOKMARK_TO_REMOVE=$(echo "$BOOKMARKS" | ~/scripts/dmenu.sh -l 10 -p "Select bookmark to remove:")

        if [ -z "$BOOKMARK_TO_REMOVE" ]; then
            echo "No bookmark selected. Exiting."
            exit 0
        fi

        # Remove the bookmark
        remove_bookmark "$SECTION" "$BOOKMARK_TO_REMOVE"
    fi
}

# Run the main function
main "$@"
