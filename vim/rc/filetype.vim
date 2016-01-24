scriptencoding utf-8
"-----------------------------------------------------------------------------
" FileType:
"

" smart autoindent
set autoindent
set smartindent

augroup VimrcAutocmd
  autocmd FileType * call s:on_filetype()

  autocmd FileType gitcommit setlocal nofoldenable
  autocmd FileType ref nnoremap <buffer> <TAB> <C-w>w
  autocmd BufReadPost *.tpl set filetype=smarty.html
  autocmd FileType haskell setlocal shiftwidth=2
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*}
        \ setlocal filetype=markdown wrap | let b:not_del_last_whitespaces = 1
augroup END

function! s:on_filetype() abort " {{{
  " 自動的にコメントを追加するのを無効にする
  setlocal formatoptions-=ro
  " 行を連結する際にマルチバイト文字の前後や間に空白を挿入しない
  setlocal formatoptions+=MB

  " help以外はFoldCCtextを使う
  if &filetype !=# 'help' && exists('*FoldCCtext')
    setlocal foldtext=FoldCCtext()
  endif

  " 自動折り返しを無効にする
  if &l:textwidth != 70 && &filetype !=# 'help'
    setlocal textwidth=0
  endif

  if !&l:modifiable
    setlocal nofoldenable
    setlocal foldcolumn=0
  endif

  " helpやquickfixはqで閉じれるようにする
  if &buftype ==# 'help' || &buftype ==# 'quickfix'
    nnoremap <silent> <buffer> q :bdelete<CR>
  endif
endfunction

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
      \   'sass',
      \   'xml',
      \   'vim',
      \   'php',
      \ ]

" ユーザコマンドのシンタックスハイライト
augroup syntax-highlight-extends
  autocmd!
  autocmd Syntax vim call s:set_syntax_of_user_defined_commands()
augroup END

function! s:set_syntax_of_user_defined_commands() " {{{
  redir => _
  silent! command
  redir END

  let command_names = join(
        \   map(
        \     split(_, '\n')[1:],
        \     "matchstr(v:val, '[!\"b]*\\s\\+\\zs\\u\\w*\\ze')"
        \   )
        \ )

  if command_names == ''
    return
  endif

  execute 'syntax keyword vimCommand ' . command_names
endfunction"}}}

" 補完時のメッセージを表示しない
" Patch: https://groups.google.com/forum/#!topic/vim_dev/WeBBjkXE8H8
try
  set shortmess+=c
catch /^Vim\%((\a\+)\)\=:E539: Illegal character/
  " shortmessにcが加えられないなら、メッセージを背景色と同色にする
  autocmd MyAutoCmd VimEnter *
        \   highlight ModeMsg guifg=bg guibg=bg
        \ | highlight Question guifg=bg guibg=bg
endtry

" vim:set foldmethod=marker:
