scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:

"--------------------------------------------------------------------------------
" Initialize:
"

" <Leader>をスペースにする
let g:mapleader = "\<Space>"

if IsWindows()
  " Windowsの場合はファイル名の展開にスラッシュを使う
  set shellslash
endif

" キャッシュディレクトリを生成
let $CACHE = expand('~/.cache')
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif

" vimrcが作るautocmdをいったん全削除
augroup VimrcAutocmd
  autocmd!
augroup END

" runtimepathの初期設定
if has('vim_starting')
  if IsWindows() " {{{
    " ランタイムパスを設定する
    let &runtimepath = join(
          \ [
          \   expand('~/.vim'),
          \   expand('$VIM/runtime'),
          \   expand('~/.vim/after'),
          \ ], ',')
  endif " }}}

  " neobundleをロードする
  if &runtimepath !~ '/neobundle.vim'
    let s:neobundle_dir = expand('$CACHE/neobundle') . '/neobundle.vim'
    if !isdirectory(s:neobundle_dir)
      execute printf('!git clone %s://github.com/Shougo/neobundle.vim.git', (exists('$http_proxy') ? 'https' : 'git')) s:neobundle_dir
    endif

    execute 'set runtimepath^=' . s:neobundle_dir

    unlet s:neobundle_dir
  endif

  if has('unix')
    " Linuxならvimprocも同時に準備する
    " TODO Linuxの他にも準備できる環境はあるので改善する
    if &runtimepath !~ '/vimproc.vim'
      let s:vimproc_dir = expand('$CACHE/neobundle/') . '/vimproc.vim'
      if !isdirectory(s:vimproc_dir)
        execute printf('!git clone %s://github.com/Shougo/vimproc.vim.git', (exists('$http_proxy') ? 'https' : 'git')) s:vimproc_dir
        " ビルドする
        execute printf('!cd "%s"; make', s:vimproc_dir)
      endif

      " runtimepathへの追加はNeoBundleがやってくれる

      unlet s:vimproc_dir
    endif
  endif
endif

let g:neobundle#default_options = {}

" デフォルトのプラグインを無効化する {{{

" menu.vimを無効化
if has('gui_running')
  set guioptions=Mc
endif

let g:loaded_gzip = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1
let g:loaded_rrhelper = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_matchparen = 1

" }}}
