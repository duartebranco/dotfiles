"
" auto-things after saving
"
autocmd BufWritePost */dwm/config.h ! make clean install
autocmd BufWritePost */st/config.h ! make clean install
autocmd BufWritePost */dwmblocks/config.h ! make clean install && { killall -q dwmblocks;setsid dwmblocks & }
autocmd BufWritePost */dmenu/config.h ! make clean install

autocmd BufWritePost */picom/picom.conf !killall picom && picom -b &

autocmd BufWritePost *.tex !pdflatex %


"
" specific things on certain files
"
autocmd FileType tex setlocal spell spelllang=en_us

