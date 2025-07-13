#!/bin/sh

# Build a list of app names and their exec commands, separated by a tab.
APPS=$(find /usr/share/applications ~/.local/share/applications -name '*.desktop' 2>/dev/null | \
    while read -r desktop; do
        NAME=$(grep -m1 '^Name=' "$desktop" | cut -d= -f2-)
        EXEC=$(grep -m1 '^Exec=' "$desktop" | cut -d= -f2- | sed 's/ *%[a-zA-Z]//g' | awk '{print $1}')
		if [ -n "$NAME" ] && [ -n "$EXEC" ]; then
			# remove apps from list
			if [ "$NAME" = "Picom" ] || \
			   [ "$NAME" = "compton" ] || \
			   [ "$NAME" = "OpenJDK Java 24 Runtime" ] || \
			   [ "$NAME" = "OpenJDK Java 24 Console" ] || \
			   [ "$NAME" = "sxiv" ] || \
			   [ "$NAME" = "Zathura" ] || \
			   [ "$NAME" = "Redshift" ] || \
			   [ "$NAME" = "Pinentry" ] || \
			   [ "$NAME" = "Qt V4L2 test Utility" ] || \
			   [ "$NAME" = "Qt V4L2 video capture utility" ] || \
 			   [ "$NAME" = "Feh" ]; then
				NAME=""
				EXEC=""
			fi
			if [ -n "$NAME" ] && [ -n "$EXEC" ]; then
				printf '%s\t%s\n' "$NAME" "$EXEC"
			fi
		fi
    done | sort -u)

# Show only the names in dmenu, and get the user's choice.
CHOICE=$(printf "%s\n" "$APPS" | cut -f1 | ~/scripts/dmenu.sh -c -l 20 -p "Run: ")

# Find the corresponding exec command for the chosen name and run it.
CMD=$(printf "%s\n" "$APPS" | awk -F'\t' -v name="$CHOICE" '$1 == name {print $2; exit}')

if [ -n "$CMD" ]; then
    echo "Launching: $CHOICE ($CMD)"
	st $CMD >/dev/null 2>&1 &
fi
