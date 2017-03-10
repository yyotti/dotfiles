"-----------------------------------------------------------------------------
" For Unix:
"

" Use sh (It is faster)
set shell=sh

let $PATH = expand('~/bin') . ':/usr/local/bin/:' . $PATH

if has('gui_running')
  finish
endif

"-----------------------------------------------------------------------------
" For CUI:
"
set t_Co=256

if !has('nvim')
  set term=xterm-256color
  set t_ut=
endif

if exists('+termguicolors')
  set termguicolors
endif
