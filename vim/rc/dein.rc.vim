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

" TODO Local plugins
" let s:vimrc_local = findfile('vimrc_local.vim', '.;')
" if s:vimrc_local !=# ''
"   call dein#local(
"         \   fnamemodify(s:vimrc_local, ':h'),
"         \   { 'frozen': 1, 'merged': 0 },
"         \   [ 'vim*', 'nvim-*', 'unite-*', 'neco-*', '*.vim', 'denite.nvim' ]
"         \ )
"   call dein#local(
"         \   fnamemodify(s:vimrc_local, ':h'),
"         \   { 'frozen': 1, 'merged': 0 },
"         \   [ 'deoplete-*', '*.nvim' ]
"         \ )
" endif

call dein#end()
call dein#save_state()

if !has('vim_starting') && dein#check_install()
  let s:msg = 'Some plugins are not installed. Install now ?'
  if confirm(s:msg, '&Yes/&no') ==# 1
    call dein#install()
  endif
  unlet s:msg
endif
