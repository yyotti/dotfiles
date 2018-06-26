"-----------------------------------------------------------------------------
" deoplete.nvim:
"

" <TAB>: completion.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \   <SID>check_back_space() ? "\<TAB>" :
"       \     deoplete#manual_complete()
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1] =~ '\s'
" endfunction

" <S-TAB>: completion back.
" inoremap <expr> <S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

inoremap <expr> <C-h> deoplete#smart_close_popup() . "\<C-h>"
inoremap <expr> <BS> deoplete#smart_close_popup() . "\<C-h>"

inoremap <expr> <C-g> pumvisible() ? deoplete#cancel_popup() : "\<C-g>"
inoremap <silent><expr> <C-e> deoplete#complete_common_string()
inoremap <expr> <C-m> deoplete#refresh()

" inoremap <expr> ' pumvisible() ? deoplete#close_popup() : "'"

" Close popup and save indent
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort "{{{
  return deoplete#cancel_popup() . "\<CR>"
endfunction "}}}

call deoplete#custom#source('_', 'matchers', ['matcher_head'])
call deoplete#custom#set(
      \   '_',
      \   'converters',
      \   [
      \     'converter_remove_paren',
      \     'converter_remove_overlap',
      \     'matcher_length',
      \     'converter_truncate_abbr',
      \     'converter_truncate_menu',
      \     'converter_auto_delimiter',
      \   ]
      \ )

call deoplete#custom#option({
      \   'keyword_patterns': {
      \     '_': '[a-zA-Z_]\k*\(?',
      \   },
      \   'camel_case': v:true,
      \   'smart_case': v:true,
      \ })

" let g:deoplete#omni#functions = {}
"
" let g:deoplete#omni#input_patterns = {}
" let g:deoplete#omni#input_patterns.python = ''
