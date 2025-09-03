" file tree
nnoremap <C-t> :call ToggleTree()<CR>

function! ToggleTree()
    let was_open = exists('g:NERDTree') && g:NERDTree.IsOpen()
    NERDTreeToggle
    if !was_open
        vertical resize 20
    endif
endfunction

