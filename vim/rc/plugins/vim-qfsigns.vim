scriptencoding utf-8
"--------------------------------------------------------------------------------
" vim-qfsigns.vim
"

" 設定 {{{
let g:qfsigns#AutoJump = 1

if !exists('g:quickrun_config')
  let g:quickrun_config = {}
endif
if !has_key(g:quickrun_config, 'watchdogs_checker/_')
  let g:quickrun_config['watchdogs_checker/_'] = {}
endif
let g:quickrun_config['watchdogs_checker/_']['hook/qfsigns_update/enable_exit'] = 1
let g:quickrun_config['watchdogs_checker/_']['hook/qfsigns_update/priority_exit'] = 3

if neobundle#is_sourced('vim-watchdogs')
  call watchdogs#setup(g:quickrun_config)
endif
" }}}

" vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:
