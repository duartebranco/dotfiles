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
			   [ "$NAME" = "OpenJDK Java 11 Runtime" ] || \
			   [ "$NAME" = "OpenJDK Java 17 Runtime" ] || \
			   [ "$NAME" = "OpenJDK Java 21 Runtime" ] || \
			   [ "$NAME" = "OpenJDK Java 24 Runtime" ] || \
			   [ "$NAME" = "OpenJDK Java 25 Runtime" ] || \
			   [ "$NAME" = "OpenJDK Java 26 Runtime" ] || \
			   [ "$NAME" = "OpenJDK Java 11 Console" ] || \
			   [ "$NAME" = "OpenJDK Java 17 Console" ] || \
			   [ "$NAME" = "OpenJDK Java 21 Console" ] || \
			   [ "$NAME" = "OpenJDK Java 24 Console" ] || \
			   [ "$NAME" = "OpenJDK Java 25 Console" ] || \
			   [ "$NAME" = "OpenJDK Java 26 Console" ] || \
			   [ "$NAME" = "OpenJDK Java 11 Shell" ] || \
			   [ "$NAME" = "OpenJDK Java 17 Shell" ] || \
			   [ "$NAME" = "OpenJDK Java 21 Shell" ] || \
			   [ "$NAME" = "OpenJDK Java 24 Shell" ] || \
			   [ "$NAME" = "OpenJDK Java 25 Shell" ] || \
			   [ "$NAME" = "OpenJDK Java 26 Shell" ] || \
			   [ "$NAME" = "Avahi SSH Server Browser" ] || \
			   [ "$NAME" = "Avahi VNC Server Browser" ] || \
			   [ "$NAME" = "Avahi Zeroconf Browser" ] || \
			   [ "$NAME" = "lftp" ] || \
			   [ "$NAME" = "LRF viewer" ] || \
			   [ "$NAME" = "Portal" ] || \
			   [ "$NAME" = "Stremio Service" ] || \
			   [ "$NAME" = "ipython" ] || \
			   [ "$NAME" = "Libinput Gestures" ] || \
			   [ "$NAME" = "LibreOffice Base" ] || \
			   [ "$NAME" = "LibreOffice Math" ] || \
			   [ "$NAME" = "LibreOffice Calc" ] || \
			   [ "$NAME" = "LibreOffice Draw" ] || \
			   [ "$NAME" = "LibreOffice Impress" ] || \
			   [ "$NAME" = "LibreOffice Writer" ] || \
			   [ "$NAME" = "LibreOffice XSLT based filters" ] || \
			   [ "$NAME" = "sxiv" ] || \
			   [ "$NAME" = "Zathura" ] || \
			   [ "$NAME" = "Redshift" ] || \
			   [ "$NAME" = "Pinentry" ] || \
			   [ "$NAME" = "Qt V4L2 test Utility" ] || \
			   [ "$NAME" = "Qt V4L2 video capture utility" ] || \
			   [ "$NAME" = "Visual Studio Code - URL Handler" ] || \
			   [ "$NAME" = "VSCodium - Wayland" ] || \
			   [ "$NAME" = "VSCodium - URL Handler" ] || \
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
CHOICE=$(printf "%s\n" "$APPS" | cut -f1 | dmenu -c -l 20 -p "Run: ")

# Find the corresponding exec command for the chosen name and run it.
CMD=$(printf "%s\n" "$APPS" | awk -F'\t' -v name="$CHOICE" '$1 == name {print $2; exit}')

# Modify specific app's cmd
if [ "$CMD" = "/usr/bin/code" ]; then
    CMD="code --extensions-dir "/home/duarte/.local/share/vscode""
fi

if [ -n "$CMD" ]; then
    echo "Launching: $CHOICE ($CMD)"
	st $CMD >/dev/null 2>&1 &
fi
