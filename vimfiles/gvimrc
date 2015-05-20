scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0 foldmethod=marker:

" editexisting {{{
if !exists('g:editexisting_loaded') || g:editexisting_loaded == 0
  runtime macros/editexisting.vim
  let g:editexisting_loaded = 1
endif
" }}} editexisting

" 表示設定 {{{
" カラーテーマ
if neobundle#is_sourced('vim-colors-solarized')
  set background=light
  colorscheme solarized
else
  colorscheme desert
endif

" フォント
if has('unix')
  set guifont=Ricty\ for\ Powerline\ 11
  set linespace=1
endif

" }}} 表示設定

" ウィンドウ設定 {{{
set columns=180
set lines=50
set guioptions-=m
set guioptions-=T

" }}} ウィンドウ設定

" gif用設定 {{{
let s:in_recording = 0
function! s:toggle_recording()
  if !s:in_recording
    set columns=100
    set lines=30
    set guifont=Ricty\ For\ Powerline\ 13
  else
    set columns=180
    set lines=50
    set guifont=Ricty\ for\ Powerline\ 11
  endif

  let s:in_recording = !s:in_recording
endfunction

command! -nargs=0 ToggleRecording call <SID>toggle_recording()
" }}}
