"-----------------------------------------------------------------------------
" FileType:
"
if exists('did_load_filetypes')
  finish
endif

augroup filetypedetect
  " Smarty
  autocmd BufRead,BufNewFile *.tpl setfiletype smarty.html

  " Markdown
  autocmd BufRead,BufNewFile *.mkd,*.markdown,*.md,*.mdown,*.mkdn
        \ setfiletype markdown

  " .gitconfig
  autocmd BufRead,BufNewFile gitconfig setfiletype gitconfig
augroup END
