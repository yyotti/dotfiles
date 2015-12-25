scriptencoding utf-8
"--------------------------------------------------------------------------------
" vim-watchdogs.vim
"

" 設定 {{{
if !exists('g:quickrun_config')
  let g:quickrun_config = {}
endif
if !has_key(g:quickrun_config, 'watchdogs_checker/_')
  let g:quickrun_config['watchdogs_checker/_'] = {}
endif
let g:quickrun_config['watchdogs_checker/_']['runner/vimproc/updatetime'] = 20
let g:quickrun_config['watchdogs_checker/_']['outputter/quickfix/open_cmd'] = ''

" 書き込み後にシンタックスチェックを行う
let g:watchdogs_check_BufWritePost_enable = 1
" Haskellのチェックは無効にする
let g:watchdogs_check_BufWritePost_enables = {
      \ "haskell": 0,
      \ }

" 一定時間以上キー入力がなかった場合にシンタックスチェックを行う
" バッファに書き込み後、1度だけ行われる
let g:watchdogs_check_CursorHold_enable = 1
" Haskellのチェックは無効にする
let g:watchdogs_check_CursorHold_enables = {
      \ "haskell": 0,
      \ }

" 設定を追加してやる
call watchdogs#setup(g:quickrun_config)
" }}}

" vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:
