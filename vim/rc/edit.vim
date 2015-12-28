scriptencoding utf-8
"--------------------------------------------------------------------------------
" Edit:
"
set smarttab
" expandtabをデフォルトにしておく
set expandtab

" インデントをオプション'shiftwidth'の値の倍数に丸める
set shiftround
" タブ設定(ヘルプに書いてある1つ目のやり方だが、expandtabはオンである)
set tabstop=8
set softtabstop=4
set shiftwidth=4

" modelineを有効にする
set modeline

" クリップボード連携
if has('unnamedplus')
  set clipboard& clipboard^=unnamedplus
else
  set clipboard& clipboard^=unnamed
endif

" バックアップを作成しない
set nowritebackup
set nobackup
set noswapfile
set backupdir-=.

" バックスペースでインデントや行末を消す
set backspace=indent,eol,start

" 対応する括弧をハイライトする
set showmatch
" 括弧のハイライト時間の制御
set matchtime=1
set cpoptions-=m
" <>をハイライトする
set matchpairs+=<:>

" バッファが保存されていなくても切り替えられるようにする
set hidden

" 単語補完を行った際に、入力された文字列の大文字小文字と補完する語句の
" 大文字小文字が合っていない場合は修正する
set infercase

" 折り畳みを有効にする
set foldenable
" 折り畳みはマーカーとする
set foldmethod=marker
" 折り畳みの表示
set foldcolumn=2
set fillchars=vert:\|
set commentstring=%s

" FoldCCを使っているときはそのテキストを表示する
if exists('*FoldCCtext')
  set foldtext=FoldCCtext()
endif

" grepの設定
set grepprg=grep\ -inH

" ファイル名に使う文字から=を外す
set isfname-==

" キーマップのタイムアウトを設定する
set timeout timeoutlen=3000 ttimeoutlen=100

" CursorHoldの時間を設定
set updatetime=1000

" スワップファイルの作成場所
let s:swp_dir = expand('~/.vim/.backup')
if !isdirectory(s:swp_dir)
  call mkdir(s:swp_dir, 'p')
endif
let &directory = s:swp_dir
unlet s:swp_dir

if v:version >= 703
  " undoファイル（.*.un~）の作成場所
  set undofile
  let &undodir = &directory
endif

if v:version < 703 || (v:version == 7.3 && !has('patch336'))
  " Vimのバグらしい
  set notagbsearch
endif

" 矩形選択の際にフリーカーソルモードにする
set virtualedit=block

" デフォルトでKはmanをひくようになっているので、helpに変更
set keywordprg=:help

" INSERTモードを抜けたら、pasteモードを解除したりdiffupをしたりする
autocmd VimrcAutocmd InsertLeave * if &paste | set nopaste | echo 'nopaste' | endif
autocmd VimrcAutocmd InsertLeave * if &l:diff | diffupdate | endif

" 保存時に行末の空白を除去
autocmd VimrcAutocmd BufWritePre * call <SID>del_last_whitespaces()

function! s:del_last_whitespaces() abort " {{{
  if exists('b:not_del_last_whitespaces')
    return
  endif

  :%s/\s\+$//ge
endfunction " }}}

" Ctrl+a,Ctrl+xでインクリメント、デクリメントするときに、先頭に
" 0詰めされた 001 などを8進数ではなく普通の数字とみなす
set nf=

" シンボリックリンクをリンク先で開く
command! OpenSymlinkTarget call <SID>open_symlink_target()
function! s:open_symlink_target() abort " {{{
  let fpath = resolve(expand('%:p'))
  let bufname = bufname('%')
  let pos = getpos('.')

  enew
  exec 'bwipeout ' . bufname
  exec 'edit ' . fpath
  call setpos('.', pos)
endfunction " }}}

" Git管理下のファイルを開いたら、.gitがあるディレクトリにカレントを移動する
if executable('git')
  autocmd VimrcAutocmd BufWinEnter * call s:cd_gitroot()

  function! s:trim(str) abort " {{{
    return substitute(a:str, '^[\r\n]*\(.\{-}\)[\r\n]*$', '\1', '')
  endfunction " }}}

  function! s:cd_gitroot() abort " {{{
    " まず現在のディレクトリを保存
    let dir = getcwd()

    " バッファのパスにとりあえず移動する
    let buf_path = expand('%:p')
    if !isdirectory(buf_path)
      let buf_path = fnamemodify(buf_path, ':h')
    endif
    if !isdirectory(buf_path)
      return
    endif
    execute 'lcd' buf_path

    " gitディレクトリの中にいるかチェック
    let in_git_dir = s:trim(system('git rev-parse --is-inside-work-tree'))
    if in_git_dir !=# 'true'
      execute 'lcd' dir
      return
    endif

    " gitディレクトリのルートに移動
    let git_root = s:trim(system('git rev-parse --show-toplevel'))
    execute 'lcd' git_root
  endfunction " }}}
endif

" vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:
