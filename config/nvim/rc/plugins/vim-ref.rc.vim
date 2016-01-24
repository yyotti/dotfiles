scriptencoding utf-8
"-----------------------------------------------------------------------------
" vim-ref.vim:
"
let g:ref_cache_dir = expand('$CACHE/vim_ref_cache')
if IsWindows()
  let g:ref_refe_encoding = 'cp932'
endif

" PHP
let g:ref_phpmanual_path = $HOME . '/.vim/refs/php-chunked-xhtml'

autocmd NvimAutocmd FileType ref-* nnoremap <silent> <buffer> q :bdelete<CR>

" vim:set foldmethod=marker:
