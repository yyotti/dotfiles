"-----------------------------------------------------------------------------
" For Unix:
"
if exists('$WINDIR') || !executable('zsh')
  " Cygwin
  set shell=bash
else
  set shell=zsh
endif

let $PATH = expand('~/bin') . ':/usr/local/bin/:' . $PATH

if has('gui_running')
  finish
endif

"-----------------------------------------------------------------------------
" For CUI:
"
if !has('nvim')
  set t_ut=
  set t_Co=256
endif
