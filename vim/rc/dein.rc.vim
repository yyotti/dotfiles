"---------------------------------------------------------------------------
" Dein:
"

let s:path = vimrc#join_path($_CACHE, 'dein')
if !dein#load_state(s:path)
  finish
endif

call dein#begin(s:path, expand('<sfile>'))

call dein#load_toml(
      \ vimrc#join_path($VIMDIR, 'rc/dein/dein.toml'), { 'lazy': 0 })
call dein#load_toml(
      \ vimrc#join_path($VIMDIR, 'rc/dein/lazy.toml'), { 'lazy': 1 })
call dein#load_toml(vimrc#join_path($VIMDIR, 'rc/dein/ft.toml'))

" Local plugins
let s:local_dein_toml = vimrc#join_path($HOME, '.dein_local.toml')
if filereadable(s:local_dein_toml)
  call dein#load_toml(s:local_dein_toml,
        \ { 'local': 1, 'frozen': 1, 'merged': 0 })
endif

call dein#end()
call dein#save_state()

if !has('vim_starting') && dein#check_install()
  let s:msg = 'Some plugins are not installed. Install now ?'
  if confirm(s:msg, '&Yes/&no') ==# 1
    call dein#install()
  endif
  unlet s:msg
endif
