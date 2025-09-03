" toggle paste for pasting
set pastetoggle=<F2>

" Select All
nnoremap <C-a> ggVG

" terminal normal mode
tnoremap <Esc> <C-\><C-n>

" Copy
vnoremap <C-c> "+y
nnoremap <C-c> "+yy

" resize windows
execute "set <M-h>=\eh"
execute "set <M-l>=\el"
nnoremap <M-h> :vertical resize -5<CR>
nnoremap <M-l> :vertical resize +5<CR>

" buffers
execute "set <M-b>=\eb"
execute "set <M-n>=\en"
execute "set <M-q>=\eq"
nnoremap <M-b> :ls<CR>
nnoremap <M-n> :bnext<CR>
nnoremap <M-q> :bdelete<CR>

" terminal window
nnoremap <C-j> :botright vert term ++cols=60<CR>

