#!/bin/bash

# Function to fetch and display song info
update_song_info() {
    title=$(mpc --format "%title%" current 2>/dev/null)
    artist=$(mpc --format "%artist%" current 2>/dev/null)
    album=$(mpc --format "%album%" current 2>/dev/null)

    # Only notify if song info exists
    if [ -n "$title" ]; then
        notify-send -i /home/duarte/.cache/album_art/"$title"_cover.png  "󰎇 Now Playing" "$artist - $title \n[$album]"
    fi

    # Update dwmblocks
    pkill -RTMIN+12 dwmblocks
}

mpc current > /tmp/mpd_current_song

while true; do
    mpc idle player > /dev/null
    new_song=$(mpc current)
    old_song=$(cat /tmp/mpd_current_song)
    
    if [[ "$new_song" != "$old_song" ]]; then
        echo "$new_song" > /tmp/mpd_current_song
		update_song_info
    fi
done
