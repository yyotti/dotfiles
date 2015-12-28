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

" grepに使うコマンドを指定。
" 優先順位は hw > pt > ag > git > grep  (ptは日本語を扱えるということで)
" ただ、hwは不安定らしく同じ条件で検索しても結果が異なる。
" if executable('hw')
"   " https://github.com/tkengo/highway
"   let g:unite_source_grep_command = 'hw'
"   let g:unite_source_grep_default_opts = '--no-group --no-color -n -a -i'
"   let g:unite_source_grep_recursive_opt = ''
if executable('pt')
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor -i'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ag')
  " TODO オプションは改めて見直す必要がある
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = "-i --vimgrep --nocolor --nogroup --hidden --ignore '.hg' --ignore '.svn' --ignore '.git' --ignore '.bzr'"
  let g:unite_source_grep_recursive_opt = ''
elseif executable('git')
  let g:unite_source_grep_command = 'git'
  let g:unite_source_grep_default_opts = '--no-index --no-color --exclude-standard -I --line-number -i'
  let g:unite_source_grep_recursive_opt = ''
endif

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
