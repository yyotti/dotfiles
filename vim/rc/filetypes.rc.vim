" Vim
let g:vimsyntax_noerror = 1

" Bash
let g:is_bash = 1

" python.vim
let g:python_highlight_all = 1

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

" Folding
let g:xml_syntax_folding = 1

" Disable PHP formatoptions
let g:PHP_autoformatcomment = 0

" Update filetype
autocmd MyAutocmd BufWritePost * nested
      \ if &l:filetype ==# '' || exists('b:ftdetect') |
      \   unlet! b:ftdetect |
      \   filetype detect |
      \ endif

" " Auto reload *.vim files
" autocmd MyAutocmd BufWritePost .vimrc,vimrc,*.rc.vim,vimrc.local nested
"       \ source $MYVIMRC | redraw

" Auto reload VimScript
" autocmd MyAutocmd BufWritePost,FileWritePost *.vim nested
"       \ if &l:autoread > 0 |
"       \   source <afile> |
"       \   echo 'source ' . bufname('%') |
"       \ endif

" Highlight whitespaces (EOL)
highlight default link WhitespaceEOL Error
match WhitespaceEOL /\s\+$/

autocmd MyAutocmd FileType * call s:after_ftplugin()
function! s:after_ftplugin() abort " {{{
  " Disable automatically insert comment
  setlocal formatoptions-=ro
  setlocal formatoptions+=mMBl

  " Disable auto wrap
  if &l:textwidth != 70 && &filetype !=# 'help'
    setlocal textwidth=0
  endif

  " Use foldCCtext()
  if &filetype !=# 'help' && exists('*FoldCCtext')
    setlocal foldtext=FoldCCtext()
  endif

  if !&l:modifiable
    setlocal nofoldenable
    setlocal foldcolumn=0

    if v:version >= 703
      setlocal colorcolumn=
    endif
  endif
endfunction "}}}
