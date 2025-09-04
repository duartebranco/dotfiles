#!/usr/bin/env python3
"""
Bookmark manager script for HTML bookmark files
Works with dmenu bookmark manager bash script
"""

import sys
import os
import re
from html import escape

def read_file(filepath):
    """Read the bookmark file content"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            return f.read()
    except Exception as e:
        print(f"Error reading file: {e}", file=sys.stderr)
        sys.exit(1)

def write_file(filepath, content):
    """Write content to the bookmark file"""
    try:
        # Create directory if it doesn't exist
        os.makedirs(os.path.dirname(filepath), exist_ok=True)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
    except Exception as e:
        print(f"Error writing file: {e}", file=sys.stderr)
        sys.exit(1)

def add_bookmark(filepath, section_name, url, text):
    """Add a bookmark to the specified section with proper indentation"""
    content = read_file(filepath)

    # Find section
    section_line = '<h2>' + section_name + '</h2>'
    section_pos = content.find(section_line)
    if section_pos == -1:
        print(f"Error: Section '{section_name}' not found", file=sys.stderr)
        sys.exit(1)

    # Find the corresponding </ul> after this section
    ul_end_pos = content.find('</ul>', section_pos)
    if ul_end_pos == -1:
        print(f"Error: No </ul> found after section '{section_name}'", file=sys.stderr)
        sys.exit(1)

    # Find the line before </ul> and duplicate it
    lines = content.split('\n')
    char_count = 0
    for i, line in enumerate(lines):
        char_count += len(line) + 1  # +1 for the newline
        if char_count > ul_end_pos:
            ul_line_index = i
            break

    # Get the line before </ul> and duplicate it
    line_before_ul = lines[ul_line_index - 1]

    new_line = line_before_ul
    # Replace href attribute
    new_line = re.sub(r'href="[^"]*"', f'href="{escape(url)}"', new_line)
    # Replace text content between > and </a>
    new_line = re.sub(r'>([^<]*)</a>', f'>{escape(text)}</a>', new_line)

    lines.insert(ul_line_index, new_line)

    new_content = '\n'.join(lines)
    write_file(filepath, new_content)
    print(f"Bookmark added to section '{section_name}'")


def remove_bookmark(filepath, section_name, bookmark_text):
    """Remove a bookmark from the specified section"""
    content = read_file(filepath)

    # Find the section
    section_line = '<h2>' + section_name + '</h2>'
    section_pos = content.find(section_line)
    if section_pos == -1:
        print(f"Error: Section '{section_name}' not found", file=sys.stderr)
        sys.exit(1)

    # Split content into lines and find the line containing the pattern
    lines = content.split('\n')
    pattern = '>' + bookmark_text + '</a></li>'

    # Find and remove the line containing the pattern
    found = False
    for i, line in enumerate(lines):
        if pattern in line:
            lines.pop(i)
            found = True
            break

    new_content = '\n'.join(lines)
    write_file(filepath, new_content)
    print(f"Removed bookmark '{bookmark_text}' from section '{section_name}'")

def main():
    if len(sys.argv) < 2:
        print("Usage: bookmark.py <add|remove> [args...]", file=sys.stderr)
        print("  add <section> <url> <text>", file=sys.stderr)
        print("  remove <section> <text>", file=sys.stderr)
        sys.exit(1)

    # Get bookmark file path
    bookmark_file = os.path.expanduser("~/app/startpage/bookmarks.html")

    action = sys.argv[1].lower()
    if action == "add":
        if len(sys.argv) != 5:
            print("Error: add requires exactly 3 arguments: <section> <url> <text>", file=sys.stderr)
            sys.exit(1)

        section = sys.argv[2]
        url = sys.argv[3]
        text = sys.argv[4]

        add_bookmark(bookmark_file, section, url, text)
    elif action == "remove":
        if len(sys.argv) != 4:
            print("Error: remove requires exactly 2 arguments: <section> <text>", file=sys.stderr)
            sys.exit(1)

        section = sys.argv[2]
        text = sys.argv[3]

        remove_bookmark(bookmark_file, section, text)
    else:
        print(f"Error: Unknown action '{action}'. Use 'add' or 'remove'", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
