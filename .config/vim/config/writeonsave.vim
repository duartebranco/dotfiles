"
" auto-things after saving
"
autocmd BufWritePost */dwm/config.h !sudo make clean install
autocmd BufWritePost */st/config.h !sudo make clean install
autocmd BufWritePost */dwmblocks/config.h !sudo make clean install && { killall -q dwmblocks;setsid dwmblocks & }
autocmd BufWritePost */dmenu/config.h !sudo make clean install

autocmd BufWritePost */picom/picom.conf !killall picom && picom -b &

