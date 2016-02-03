scriptencoding utf-8
"-----------------------------------------------------------------------------
" Edit:
"
set expandtab

set shiftround

" クリップボード連携
set clipboard&
set clipboard+=unnamedplus

" バックアップを作成しない
set nowritebackup
set noswapfile
set backupdir-=.

set showmatch
set matchtime=1
set matchpairs+=<:>

set hidden

" 単語補完を行った際に、入力された文字列の大文字小文字と補完する語句の
" 大文字小文字が合っていない場合は修正する
set infercase

set foldmethod=marker
set foldcolumn=2
set fillchars=vert:\|
set commentstring=%s

if exists('*FoldCCtext')
  set foldtext=FoldCCtext()
endif

set grepprg=grep\ -inH

" ファイル名に使う文字から=を外す
set isfname-==

" キーマップのタイムアウト
set timeout
set timeoutlen=3000
set ttimeoutlen=100

set updatetime=1000

set undofile

set virtualedit=block

set keywordprg=:help

autocmd NvimAutocmd WinEnter * checktime

autocmd NvimAutocmd InsertLeave *
      \ if &paste | setlocal nopaste | echo 'nopaste' | endif
autocmd NvimAutocmd InsertLeave *
      \ if &l:diff | diffupdate | endif

" 保存時に行末の空白を除去
autocmd NvimAutocmd BufWritePre * call <SID>del_last_whitespaces()
function! s:del_last_whitespaces() abort "{{{
  if exists('b:not_del_last_whitespaces')
    return
  endif

  if &binary || &diff
    return
  endif

  normal! :%s/\s\+$//ge
endfunction "}}}

" Ctrl+aやCtrl+xでインクリメント/デクリメントするとき、先頭に
" 0詰めされた 001 などを8進数ではなく10進数とみなす
set nrformats=

" Git管理下のファイルを開いたら、.gitがあるディレクトリにカレントを移動する
if executable('git')
  autocmd NvimAutocmd BufWinEnter * call s:cd_gitroot()

  function! s:trim(str) abort "{{{
    return substitute(a:str, '^[\r\n]*\(.\{-}\)[\r\n]*$', '\1', '')
  endfunction "}}}

  function! s:cd_gitroot() abort "{{{
    let l:dir = getcwd()

    let l:buf_path = expand('%:p')
    if !isdirectory(l:buf_path)
      let l:buf_path = fnamemodify(l:buf_path, ':h')
    endif
    if !isdirectory(l:buf_path)
      return
    endif
    execute 'lcd' l:buf_path

    let l:in_git_dir = s:trim(system('git rev-parse --is-inside-work-tree'))
    if l:in_git_dir !=# 'true'
      execute 'lcd' l:dir
      return
    endif

    let l:git_root = s:trim(system('git rev-parse --show-toplevel'))
    execute 'lcd' l:git_root
  endfunction "}}}
endif

" vim:set foldmethod=marker:
