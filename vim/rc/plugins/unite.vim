scriptencoding utf-8
"--------------------------------------------------------------------------------
" unite.vim
"

" 設定 {{{
" 履歴のMAX
let g:neomru#file_mru_limit = 200

" INSERTモードで起動する
call unite#custom#profile('default', 'context', {
      \   'start_insert': 1,
      \ })

" TODO grepのための設定を記述する
" hwだったりagだったりの他にggrepも追加

" unite-menu {{{
let g:unite_source_menu_menus = {}
let g:unite_source_menu_menus.enc = {
      \   'description': 'Open with a specific character code again.',
      \ }
let g:unite_source_menu_menus.enc.command_candidates = [
      \   [ 'utf8', 'Utf8' ],
      \   [ 'iso2022jp', 'Iso2022jp' ],
      \   [ 'cp932', 'Cp932' ],
      \   [ 'euc', 'Euc' ],
      \   [ 'utf16', 'Utf16' ],
      \   [ 'utf16-be', 'Utf16be' ],
      \   [ 'jis', 'Jis' ],
      \   [ 'sjis', 'Sjis' ],
      \   [ 'unicode', 'Unicode' ],
      \ ]

let g:unite_source_menu_menus.fenc = {
      \   'description': 'Change file fenc option.',
      \ }
let g:unite_source_menu_menus.fenc.command_candidates = [
      \   [ 'utf8', 'WUtf8' ],
      \   [ 'iso2022jp', 'WIso2022jp' ],
      \   [ 'cp932', 'WCp932' ],
      \   [ 'euc', 'WEuc' ],
      \   [ 'utf16', 'WUtf16' ],
      \   [ 'utf16-be', 'WUtf16be' ],
      \   [ 'jis', 'WJis' ],
      \   [ 'sjis', 'WSjis' ],
      \   [ 'unicode', 'WUnicode' ],
      \ ]

let g:unite_source_menu_menus.ff = {
      \   'description': 'Change file format option.',
      \ }
let g:unite_source_menu_menus.ff.command_candidates = {
      \   'unix': 'WUnix',
      \   'dos': 'WDos',
      \   'mac': 'WMac',
      \ }

" }}}

" unite-alias {{{
let g:unite_source_alias_aliases = {}
let g:unite_source_alias_aliases.message = {
      \   'source': 'output',
      \   'args': 'message',
      \ }
let g:unite_source_alias_aliases.scripts = {
      \   'source': 'output',
      \   'args': 'scriptnames',
      \ }
" }}}
" }}}

" vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:
