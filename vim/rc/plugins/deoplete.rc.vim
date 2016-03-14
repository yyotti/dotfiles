"-----------------------------------------------------------------------------
" deoplete.nvim:
"
set completeopt+=noinsert

inoremap <expr> <C-h> deoplete#mappings#smart_close_popup() . "\<C-h>"
inoremap <expr> <BS> deoplete#mappings#smart_close_popup() . "\<C-h>"

" Close popup and save indent
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort "{{{
  return deoplete#mappings#close_popup() . "\<CR>"
endfunction "}}}

call deoplete#custom#set(
      \   '_',
      \   'converters',
      \   [
      \     'converter_auto_paren',
      \   ]
      \ )

let g:deoplete#keyword_patterns = {}
let g:deoplete#keyword_patterns._ = '[a-zA-Z_]\k*\(?'

let g:deoplete#omni#functions = {}

let g:deoplete#omni#input_patterns = {}
let g:deoplete#omni#input_patterns.python = ''

let g:deoplete#enable_refresh_always = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#enable_smart_case = 1
