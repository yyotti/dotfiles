scriptencoding utf-8
"--------------------------------------------------------------------------------
" Encoding:
"
" 文字コードを自動判別する

" 読み書きするエンコーディング(Unixのデフォルト)をセット
if has('vim_starting')
  set encoding=utf-8
endif

" ターミナルのエンコーディングをセット {{{
if !has('gui_running')
  if &term ==# 'win32' && (v:version < 703 || v:version == 703 && has('patch814'))
    " 非GUIの日本語コンソールの場合

    " これをしないと化ける
    set termencoding=cp932
    " これをしないと日本語入力自体が変更される。
    " 文字コードの自動判別が不可能なことに注意。
    set encoding=japan
  else
    if $ENV_ACCESS ==# 'linux'
      set termencoding=euc-jp
    elseif $ENV_ACCESS ==# 'colinux'
      set termencoding=utf-8
    else " fallback
      set termencoding=  " 'encoding'と同じ
    endif
  endif
elseif IsWindows()
  set termencoding=cp932
endif
" }}}

" 文字コードの自動判別 {{{
if !exists('did_encoding_settings') && has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'

  " iconvが JIS X 0213 をサポートしているか？
  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213,euc-jp'
    let s:enc_jis = 'iso-2022-jp-3'
  endif

  " エンコーディングを生成する
  let &fileencodings = 'ucs-bom'
  if &encoding !=# 'utf-8'
    let &fileencodings .= ',' . 'ucs-2le'
    let &fileencodings .= ',' . 'ucs-2'
  endif
  let &fileencodings .= ',' . s:enc_jis
  let &fileencodings .= ',' . 'utf-8'

  if &encoding ==# 'utf-8'
    let &fileencodings .= ',' . s:enc_euc
    let &fileencodings .= ',' . 'cp932'
  elseif &encoding =~# '^euc-\%(jp\|jisx0213\)$'
    let &encoding = s:enc_euc
    let &fileencodings .= ',' . 'cp932'
    let &fileencodings .= ',' . &encoding
  else " cp932
    let &fileencodings .= ',' . s:enc_euc
    let &fileencodings .= ',' . &encoding
  endif
  let &fileencodings .= ',' . 'cp932'

  unlet s:enc_euc
  unlet s:enc_jis

  let g:did_encoding_settings = 1
endif
" }}}

if has('kaoriya')
  " kaoriyaのみ
  set fileencodings=guess
endif

" 日本語を含んでいない場合、'encoding'を'fileencoding'として使う
" ただし調べるのは先頭から100行まで
autocmd VimrcAutocmd BufReadPost * call s:re_check_fenc()
function! s:re_check_fenc() abort " {{{
  let is_multi_byte = search("[^\x01-\x7e]", 'n', 100, 100)
  if &fileencoding =~# 'iso-2022-jp' && !is_multi_byte
    let &fileencoding = &encoding
  endif
endfunction " }}}

" デフォルトのff
set fileformat=unix
" 改行コードの自動判別
set fileformats=unix,dos,mac

" 特定の文字コードで開くためのコマンド群 {{{
" UTF-8で開く
command! -bang -bar -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
" iso-2022-jpで開く
command! -bang -bar -complete=file -nargs=? Iso2022jp edit<bang> ++enc=iso-2022-jp <args>
" cp932で開く
command! -bang -bar -complete=file -nargs=? Cp932 edit<bang> ++enc=cp932 <args>
" EUC-JPで開く
command! -bang -bar -complete=file -nargs=? Euc edit<bang> ++enc=euc-jp <args>
" UTF-16で開く
command! -bang -bar -complete=file -nargs=? Utf16 edit<bang> ++enc=ucs-2le <args>
" UTF-16BEで開く
command! -bang -bar -complete=file -nargs=? Utf16be edit<bang> ++enc=ucs-2 <args>

" エイリアス
command! -bang -bar -complete=file -nargs=? Jis Iso2022jp<bang> <args>
command! -bang -bar -complete=file -nargs=? Sjis Cp932<bang> <args>
command! -bang -bar -complete=file -nargs=? Unicode Utf16<bang> <args>
" }}}

" fencを変更するコマンド {{{
" !!! 危険なので保存しないこと !!!
command! WUtf8 setlocal fenc=utf-8
command! WIso2022jp setlocal fenc=iso-2022-jp
command! WCp932 setlocal fenc=cp932
command! WEuc setlocal fenc=euc-jp
command! WUtf16 setlocal fenc=ucs-2le
command! WUtf16be setlocal fenc=ucs-2

" エイリアス
command! WJis WIso2022jp
command! WSjis WCp932
command! WUnicode WUtf16
" }}}

" 改行コードを指定して保存 {{{
command! -bang -complete=file -nargs=? WUnix write<bang> ++fileformat=unix <args> | edit <args>
command! -bang -complete=file -nargs=? WDos write<bang> ++fileformat=dos <args> | edit <args>
command! -bang -complete=file -nargs=? WMac write<bang> ++fileformat=mac <args> | edit <args>
" }}}

if has('multi_byte_ime')
  " Win32 IMEサポートがある場合
  set iminsert=0
  set imsearch=0
endif

" vim:set sw=2 foldmethod=marker:
