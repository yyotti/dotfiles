scriptencoding utf-8
"-----------------------------------------------------------------------------
" FileType:
"
set smartindent

augroup NvimAutocmd
  autocmd FileType,Syntax * call s:on_filetype()

  autocmd BufReadPost *.tpl set filetype=smarty.html
  autocmd FileType haskell setlocal shiftwidth=2
  autocmd FileType javascript,css setlocal shiftwidth=4
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*}
        \ setlocal filetype=markdown | let b:not_del_last_whitespaces = 1

  " filetypeを更新する
  autocmd BufWritePost *
        \ if &l:filetype ==# '' || exists('b:ftdetect')
        \ |   unlet! b:ftdetect
        \ |   filetype detect
        \ | endif

augroup END

function! s:on_filetype() abort "{{{
  " 自動的にコメントを追加するのを無効にする
  setlocal formatoptions-=ro
  " 行を連結する際にマルチバイト文字の前後や間に空白を挿入しない
  setlocal formatoptions+=mMBl

  " help以外はFoldCCtextを使う
  if &filetype !=# 'help' && exists('*FoldCCtext')
    setlocal foldtext=FoldCCtext()
  endif

  if &l:textwidth != 70 && &filetype !=# 'help'
    setlocal textwidth=0
  endif

  if !&l:modifiable
    setlocal nofoldenable
    setlocal foldcolumn=0
    setlocal colorcolumn=
  endif

  " helpやquickfixはqで閉じれるようにする
  if &buftype ==# 'help' || &buftype ==# 'quickfix'
    nnoremap <silent> <buffer> q :bdelete<CR>
  endif
endfunction "}}}

" python.vim
let g:python_highlight_all = 1

" bashスクリプトの色付けが綺麗になるらしい
let g:is_bash = 1

" markdownの色付け設定
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

" 補完時のメッセージを表示しない
set shortmess+=c

" vim:set foldmethod=marker:
