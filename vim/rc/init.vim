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
endif

let g:neobundle#default_options = {}

" デフォルトのプラグインを無効化する {{{

" menu.vimを無効化
" gui.vimでguioptionsにMを入れているので、これをやらなくてもいいような気はする
let g:did_install_default_menus = 1

" GetLatestVimPlugin.vim
if !&verbose
  let g:loaded_getscriptPlugin = 1
endif

" デフォルトのファイラ netrw を無効化
let g:loaded_netrwPlugin = 1

let g:loaded_matchparen = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimballPlugin = 1

" }}}
