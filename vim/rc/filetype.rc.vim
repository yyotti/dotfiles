"-----------------------------------------------------------------------------
" FileType:
"
augroup MyAutocmd
  autocmd FileType,Syntax,BufNew * call s:on_filetype()

  autocmd BufReadPost *.tpl set filetype=smarty.html
  autocmd FileType haskell setlocal shiftwidth=2
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*}
        \ setlocal filetype=markdown
  autocmd FileType json setlocal conceallevel=0

augroup END

function! s:on_filetype() abort "{{{

  if &buftype ==# 'help' || &buftype ==# 'quickfix'
    nnoremap <silent> <buffer> q :q<CR>
  endif
endfunction "}}}
