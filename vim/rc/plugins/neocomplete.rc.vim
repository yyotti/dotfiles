"-----------------------------------------------------------------------------
" neocomplete.rc.vim:
"
let g:neocomplete#disable_auto_complete = 0

let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_camel_case = 1

let g:neocomplete#enable_fuzzy_completion = 1

let g:neocomplete#auto_completion_start_length = 2
let g:neocomplete#manual_completion_start_length = 0
let g:neocomplete#min_keyword_length = 3

let g:neocomplete#enable_auto_select = 1
let g:neocomplete#enable_cursor_hold_i = 0

let g:neocomplete#sources#dictionary#dictionaries = {
      \   'default': '',
      \ }

let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#disable_auto_select_buffer_name_pattenrn = '\[Command Line\]'
let g:neocomplete#max_list = 100

if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
if !exists('g:neocomplete#sources#omni#functions')
  let g:neocomplete#sources#omni#functions = {}
endif
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#enable_auto_close_preview = 1

if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns._ = '\h\k*(\?'

call neocomplete#custom#source('look', 'min_pattern_length', 4)
call neocomplete#custom#source(
      \   '_',
      \   'converters',
      \   [
      \     'converter_add_paren',
      \     'converter_remove_overlap',
      \     'converter_delimiter',
      \     'converter_abbr'
      \   ]
      \ )

inoremap <expr> <C-f> pumvisible() ? "\<PageDown>" : "\<Right>"
inoremap <expr> <C-b> pumvisible() ? "\<PageUp>" : "\<Left>"
inoremap <expr> <C-h> neocomplete#smart_close_popup() . "\<C-h>"
inoremap <expr> <BS> neocomplete#smart_close_popup() . "\<C-h>"
inoremap <expr> <C-n> pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>\<Down>"
inoremap <expr> <C-p> pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"

inoremap <silent> <CR> <C-r>=<SID>cr_function()<CR>
function! s:cr_function() abort "{{{
  return neocomplete#smart_close_popup() . "\<CR>"
endfunction "}}}

let g:neocomplete#fallback_mappings = [ "\<C-x>\<C-o>", "\<C-x>\<C-n>" ]
