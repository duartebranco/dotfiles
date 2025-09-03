" statusline
function! Mode()
	let l:mode =mode()
	return l:mode ==# 'n' ? 'NORMAL' :
		 \ l:mode ==# 'i' ? (&paste ? 'INSERT (paste)' : 'INSERT') :
		 \ l:mode ==# 'R' ? 'REPLACE' :
		 \ l:mode =~# 'v' ? 'VISUAL' :
		 \ l:mode =~# 'V' ? 'VISUAL LINE' :
		 \ l:mode ==# "\<C-v>" ? 'VISUAL BLOCK' :
		 \ toupper(l:mode)
endfunction

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0 ? '  '.l:branchname.' ' : ' 󱓌 no git repo '
endfunction

set laststatus=2
set noshowmode

set statusline=
" set statusline+=\ \
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
set statusline+=%#LineNr#
set statusline+=\ %F
set statusline+=\ %m

set statusline+=%=

set statusline+=%#PmenuSel#
set statusline+=\[%{Mode()}]
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ [%{&fileformat}\]
set statusline+=\ %l:%c
set statusline+=\

