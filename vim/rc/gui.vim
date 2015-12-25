scriptencoding utf-8
"--------------------------------------------------------------------------------
" GUI:
"

"--------------------------------------------------------------------------------
" Font:
"
set ambiwidth=double

set linespace=2

if has('win32') || has('win64')
  " Windows
  " TODO この中の設定は実環境で確認できていない
  set guifont=Ricty\ for\ Powerline:h11
  set guifontwide=Ricty\ for\ Powerline:h11

  if has('patch-7.4.394')
    " DirectWriteを使う
    set renderoptions=type:dirextx,gammma:2.2,mode:3
  endif

  if has('kaoriya')
    set ambiwidth=auto
  endif
else
  " Linux
  set guifont=Ricty\ for\ Powerline\ 11
endif

"--------------------------------------------------------------------------------
" Window:
"
if has('win32') || has('win64')
  " Windows
  " TODO この中の設定は実環境で確認できていない
  set columns=230
  set lines=55
else
  " Linux
  set columns=180
  set lines=50
endif

"--------------------------------------------------------------------------------
" Menu:
"
" menu.vimを読み込まない+単純な選択にはコンソールダイアログを使う
set guioptions=+Mc
set guioptions-=m
set guioptions-=T

"--------------------------------------------------------------------------------
" Others:
"
" gif用設定 {{{
" let s:in_recording = 0
" function! s:toggle_recording()
"   if !s:in_recording
"     set columns=100
"     set lines=30
"     set guifont=Ricty\ For\ Powerline\ 13
"   else
"     set columns=180
"     set lines=50
"     set guifont=Ricty\ for\ Powerline\ 11
"   endif
"
"   let s:in_recording = !s:in_recording
" endfunction
"
" command! -nargs=0 ToggleRecording call <SID>toggle_recording()
" }}}

" vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:
