"-----------------------------------------------------------------------------
" deoplete.nvim:
"
inoremap <expr> <C-h> deoplete#smart_close_popup() . "\<C-h>"
inoremap <expr> <BS> deoplete#smart_close_popup() . "\<C-h>"

" Close popup and save indent
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort "{{{
  return deoplete#cancel_popup() . "\<CR>"
endfunction "}}}

call deoplete#custom#set(
      \   '_',
      \   'converters',
      \   [
      \     'converter_remove_paren',
      \     'converter_remove_overlap',
      \     'converter_truncate_abbr',
      \     'converter_truncate_menu',
      \     'converter_auto_delimiter',
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
