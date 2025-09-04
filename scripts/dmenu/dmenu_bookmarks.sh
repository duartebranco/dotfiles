#!/bin/bash
#
# Bookmark manager script for dmenu
#
BOOKMARK_SCRIPT="$HOME/scripts/bookmark.py"
BOOKMARK_FILE="$HOME/app/startpage/bookmarks.html"
if [ ! -f "$BOOKMARK_FILE" ] || [ ! -f "$BOOKMARK_SCRIPT" ]; then
    exit 1
fi

get_sections() {
    grep -oP '<h2>\K[^<]*(?=</h2>)' "$BOOKMARK_FILE" 2>/dev/null || \
    grep -o '<h2>[^<]*</h2>' "$BOOKMARK_FILE" | sed 's/<h2>//g' | sed 's/<\/h2>//g'
}

get_bookmarks_from_section() {
    local section="$1"
    local escaped_section=$(echo "$section" | sed 's/[[\.*^$()+?{|]/\\&/g')

    # Extract bookmarks from the specific section
    awk "/<h2>$escaped_section<\/h2>/,/<\/ul>/" "$BOOKMARK_FILE" | \
    grep -o '<a href="[^"]*">[^<]*</a>' | \
    sed 's/<a href="[^"]*">//g' | \
    sed 's/<\/a>//g'
}

main() {
    # Ask for action (add or remove)
    ACTION=$(echo -e "Add\nRemove" | dmenu -l 2 -p "Bookmarks Mng:")
    if [ -z "$ACTION" ]; then
        exit 0
    fi

    # Get available sections
    SECTIONS=$(get_sections)
    if [ -z "$SECTIONS" ]; then
        exit 1
    fi

    # Ask for section
    SECTION=$(echo "$SECTIONS" | dmenu -l 10 -p "Select section:")
    if [ -z "$SECTION" ]; then
        exit 0
    fi

    if [ "$ACTION" = "Add" ]; then
        # Ask for URL
        URL=$(echo "" | dmenu -p "Enter URL:")
        if [ -z "$URL" ]; then
            exit 0
        fi

        # Ask for link text
        TEXT=$(echo "" | dmenu -p "Enter link text:")
        if [ -z "$TEXT" ]; then
            exit 0
        fi

        # Add the bookmark
        python3 "$BOOKMARK_SCRIPT" add "$SECTION" "$URL" "$TEXT"

    elif [ "$ACTION" = "Remove" ]; then
        # Get bookmarks from the selected section
        BOOKMARKS=$(get_bookmarks_from_section "$SECTION")
        if [ -z "$BOOKMARKS" ]; then
            exit 1
        fi

        # Ask which bookmark to remove
        BOOKMARK_TO_REMOVE=$(echo "$BOOKMARKS" | dmenu -l 10 -p "Select bookmark to remove:")
        if [ -z "$BOOKMARK_TO_REMOVE" ]; then
            exit 0
        fi

        # Remove the bookmark
        python3 "$BOOKMARK_SCRIPT" remove "$SECTION" "$BOOKMARK_TO_REMOVE"
    fi
}

# Run the main function
main "$@"
