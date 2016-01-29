scriptencoding utf-8
"-----------------------------------------------------------------------------
" deoplete.nvim:
"
set completeopt+=noinsert

let g:deoplete#enable_smart_case = 1

inoremap <expr> <C-h> deoplete#mappings#smart_close_popup() . "\<C-h>"
inoremap <expr> <BS>  deoplete#mappings#smart_close_popup() . "\<C-h>"

" <CR>でポップアップを閉じてインデントを保存する
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort "{{{
  return deoplete#mappings#close_popup() . "\<CR>"
endfunction "}}}

call deoplete#custom#set(
      \   '_',
      \   'converters',
      \   [
      \     'converter_auto_paren',
      \     'converter_auto_delimiter',
      \     'remove_overlap',
      \   ]
      \ )

let g:deoplete#keyword_patterns = {}
let g:deoplete#keyword_patterns._ = '[a-zA-Z_]\k*\(?'

let g:deoplete#omni#functions = {}
let g:deoplete#omni#functions.python = 'python3complete#Complete'

let g:deoplete#omni#input_patterns = {}
let g:deoplete#omni#input_patterns.python = ''

let g:deoplete#enable_refresh_always = 1

" vim:set foldmethod=marker:
