"-----------------------------------------------------------------------------
" Dein:
"
let g:dein#install_message_type = 'echo'

let s:path = expand('$CACHE/dein')
if !dein#load_state(s:path)
  finish
endif

call dein#begin(s:path, expand('<sfile>'))

call dein#load_toml('~/.vim/rc/dein.toml', { 'lazy': 0 })
call dein#load_toml('~/.vim/rc/dein_lazy.toml', { 'lazy': 1 })
if has('nvim')
  call dein#load_toml('~/.vim/rc/dein_neo.toml', {})
endif
call dein#load_toml('~/.vim/rc/dein_ft.toml')

let s:dein_local = findfile('dein_local.vim', '.;')
if s:dein_local !=# '' && filereadable(s:dein_local)
  " Load develop version
  call dein#local(fnamemodify(s:dein_local, ':h'),
        \ { 'frozen': 1, 'merged': 0 }, [ 'vim*' ])
  if has('nvim')
    call dein#local(fnamemodify(s:dein_local, ':h'),
          \ { 'frozen': 1, 'merged': 0 }, [ 'nvim*' ])
  endif
endif
unlet s:dein_local

if dein#tap('deoplete.nvim') && has('nvim')
  call dein#disable('neocomplete.vim')
endif

call dein#end()
call dein#save_state()

if !has('vim_starting') && dein#check_install()
  call dein#install()
endif
