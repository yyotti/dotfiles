scriptencoding utf-8
"-----------------------------------------------------------------------------
" vim-ref.vim:
"
let g:ref_cache_dir = expand('$CACHE/vim_ref_cache')
if IsWindows()
  let g:ref_refe_encoding = 'cp932'
endif

" TODO Windows用のテキストブラウザのパスを設定してやる

let g:ref_lynx_use_cache = 1
let g:ref_lynx_start_linenumber = 0
let g:ref_lynx_hide_url_number = 0

" PHP
let g:ref_phpmanual_path = $HOME . '/.vim/refs/php-chunked-xhtml'

autocmd NvimAutocmd FileType ref-* nnoremap <silent> <buffer> q :bdelete<CR>

" vim:set foldmethod=marker:
