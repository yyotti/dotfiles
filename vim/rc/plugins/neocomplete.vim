scriptencoding utf-8
"--------------------------------------------------------------------------------
" neocomplete.vim
"

" 設定 {{{
" スマートケース
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_camel_case = 1


" 最小の入力数
let g:neocomplete#min_keyword_length = 3

" 辞書定義
let g:neocomplete#sources#dictionary#dictionaries = {
      \   'default': '',
      \ }

" デリミタを自動入力
let g:neocomplete#enable_auto_delimiter = 1

" プレビューを自動的に閉じる
let g:neocomplete#enable_auto_close_preview = 1

" オムニ補完
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
if !exists('g:neocomplete#sources#omni#functions')
  let g:neocomplete#sources#omni#functions = {}
endif
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.python = '[^. *\t]\.\w*\|\h\w*'
let g:neocomplete#sources#omni#input_patterns.php = '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

" キーワード定義
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns._ = '\h\w*(\?'

" 補完候補取得元？
let g:neocomplete#sources#vim#complete_functions = {
      \   'Ref': 'ref#complete',
      \   'Unite': 'unite#complete_source',
      \   'VimFiler': 'vimfiler#complete',
      \ }
call neocomplete#custom#source('look', 'min_pattern_length', 4)
call neocomplete#custom#source('_', 'converters', [
      \   'converter_add_paren',
      \   'converter_remove_overlap',
      \   'converter_delimiter',
      \   'converter_abbr',
      \ ])

" TODO 要確認
" let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
" " オムニ補完
" augroup vimrc_neocomplete
"   autocmd!
"   autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"   autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"   " autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"   autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" augroup END

" }}}

" マッピング {{{
inoremap <expr> <C-f> pumvisible() ? "\<PageDown>" : "\<Right>"
inoremap <expr> <C-b> pumvisible() ? "\<PageUp>" : "\<Left>"

" <C-h>や<BS>でポップアップをクローズして1文字消す
" <C-h>の場合は入力を戻さずに、<BS>の場合は入力を戻して消すようにしておく
inoremap <expr> <C-h> neocomplete#close_popup() . "\<C-h>"
inoremap <expr> <BS> neocomplete#smart_close_popup() . "\<C-h>"

" neocomplete.
" completefuncが設定されないと無意味らしい
" inoremap <expr> <C-n> pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>\<Down>"

" キーワード補完
inoremap <expr> <C-p> pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
" inoremap <expr> ' pumvisible() ? "\<C-y>" : "'"

inoremap <silent> <expr> <C-x><C-f> neocomplete#start_manual_complete('file')

" <CR>でポップアップをクローズしてインデントを保存
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#smart_close_popup() . "\<CR>"
endfunction

" よく分からないけど、ヘルプに it is useful と書いてあるのでやっておく
let g:neocomplete#fallback_mappings = [ "\<C-x>\<C-o>", "\<C-x>\<C-n>" ]
" }}}

" vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:
