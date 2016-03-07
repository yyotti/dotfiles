scriptencoding utf-8
"-----------------------------------------------------------------------------
" GUI:
"
set ambiwidth=double

" TODO 一応、設定できてはいるが、ウィンドウが表示された後ですぐに元に戻されて
"      しまう
" autocmd NvimAutocmd BufEnter * call s:set_winsize()
" function! s:set_winsize() abort "{{{
"   if exists('g:_set_winsize')
"     return
"   endif
"
"   set lines=48
"   set columns=180
"
"   let g:_set_winsize = 1
" endfunction "}}}

" TODO ウィンドウサイズの変更はとりあえずコマンドで代用
command! SetWinsizeDefault set lines=48 columns=180

" TODO その他、フォントの設定とか
