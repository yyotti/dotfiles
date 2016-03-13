"-----------------------------------------------------------------------------
" FileType:
"
set autoindent
set smartindent

augroup MyAutocmd
  autocmd FileType,Syntax,BufEnter,BufWinEnter * call s:on_filetype()

  autocmd BufReadPost *.tpl set filetype=smarty.html
  autocmd FileType haskell setlocal shiftwidth=2
  autocmd FileType javascript,css setlocal shiftwidth=4
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*}
        \ setlocal filetype=markdown | let b:not_del_last_whitespaces = 1

  " Update filetype
  autocmd BufWritePost *
        \ if &l:filetype ==# '' || exists('b:ftdetect')
        \ |   unlet! b:ftdetect
        \ |   filetype detect
        \ | endif

augroup END

function! s:on_filetype() abort "{{{
  setlocal formatoptions-=ro
  setlocal formatoptions+=mMBl

  " TODO Move to foldCC plugin setting
  if &filetype !=# 'help' && exists('*FoldCCtext')
    setlocal foldtext=FoldCCtext()
  endif

  if &l:textwidth != 70 && &filetype !=# 'help'
    setlocal textwidth=0
  endif

  if !&l:modifiable
    setlocal nofoldenable
    setlocal foldcolumn=0
    if v:version >= 703
      setlocal colorcolumn=
    endif
  endif

  if &buftype ==# 'help' || &buftype ==# 'quickfix'
    nnoremap <silent> <buffer> q :q<CR>
  endif
endfunction "}}}

" python.vim
let g:python_highlight_all = 1

let g:is_bash = 1

" markdown colors
" http://mattn.kaoriya.net/software/vim/20140523124903.htm
let g:markdown_fenced_languages = [
      \   'css',
      \   'javascript',
      \   'js=javascript',
      \   'json=javascript',
      \   'xml',
      \   'vim',
      \   'php',
      \ ]

try
  set shortmess+=c
catch /^Vim\%((\a\+)\)\=:E539: Illegal character/
  autocmd MyAutoCmd VimEnter *
        \ highlight ModeMsg guifg=bg guibg=bg |
        \ highlight Question guifg=bg guibg=bg
endtry
