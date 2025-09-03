#!/bin/bash

confirm="$(echo -e "Yes\nNo" | dmenu -g 2 -l 1 -p "Shutdown now?")"
[ "$confirm" = "Yes" ] && shutdown -h now

