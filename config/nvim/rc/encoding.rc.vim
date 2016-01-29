scriptencoding utf-8
"-----------------------------------------------------------------------------
" Encoding:
"

" terminal encoding {{{
if !has('gui_running')
  if $ENV_ACCESS ==# 'linux'
    set termencoding=euc-jp
  elseif $ENV_ACCESS ==# 'colinux'
    set termencoding=utf-8
  else
    set termencoding=
  endif
elseif IsWindows()
  set termencoding=cp932
endif
" }}}

" 文字コードの自動判別 {{{
if !exists('g:did_encoding_settings') && has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'

  " iconvが JIS X 0213 をサポートしているか？
  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213,euc-jp'
    let s:enc_jis = 'iso-2022-jp-3'
  endif

  let &fileencodings = 'ucs-bom'
  let &fileencodings .= ',' . s:enc_jis
  let &fileencodings .= ',utf-8'
  let &fileencodings .= ',' . s:enc_euc
  let &fileencodings .= ',cp932'
  let &fileencodings .= ',cp20932'

  unlet s:enc_euc
  unlet s:enc_jis

  let g:did_encoding_settings = 1
endif
" }}}

" 日本語を含んでいない場合、 encoding を fileencoding として使う
" ただし調べるのは先頭から100行まで
autocmd NvimAutocmd BufReadPost * call s:re_check_fenc()
function! s:re_check_fenc() abort "{{{
  let l:is_multi_byte = search("[^\x01-\x7e]", 'n', 100, 100)
  if &fileencoding =~# 'iso-2022-jp' && !l:is_multi_byte
    let &fileencoding = &encoding
  endif
endfunction "}}}

" デフォルトのff
set fileformat=unix
" 改行コードの自動判別
set fileformats=unix,dos,mac

if has('multi_byte_ime')
  " Win32 IMEサポートがある場合
  set iminsert=0
  set imsearch=0
endif

" vim:set foldmethod=marker:
