scriptencoding utf-8

"-----------------------------------------------------------------------------
" Initialize_for_nvim:
"
let s:nvim_dir = fnamemodify(expand('<sfile>'), ':h')
let s:is_windows = has('win16') || has('win32') || has('win64') || has('win95')
let s:is_cygwin = has('win32unix')
let s:is_unix = has('unix')

let s:vimdev_dir = resolve(expand('~/vim_dev'))

function! s:source_rc(path) abort "{{{
  execute 'source' fnameescape(NvimDir() . '/rc/' . a:path)
endfunction "}}}

function! IsWindows() abort "{{{
  return s:is_windows
endfunction "}}}

function! IsUnix() abort "{{{
  return s:is_unix
endfunction "}}}

function! IsPowerlineEnabled() abort "{{{
  return (has('python') || has('python3')) && executable('powerline-daemon')
endfunction "}}}

function! IsHomePC() abort "{{{
  return isdirectory(s:vimdev_dir)
endfunction "}}}

function! NvimDir() abort "{{{
  return s:nvim_dir
endfunction "}}}

call s:source_rc('init.rc.vim')

" FIXME deinが正式にリリースされたら書き換える
" NeoBundle
call neobundle#begin(expand('$CACHE/neobundle'))

if neobundle#load_cache(
      \   expand('<sfile>'),
      \   NvimDir() . '/rc/neobundle.toml',
      \   NvimDir() . '/rc/neobundle.toml'
      \ )
  NeoBundleFetch 'Shougo/neobundle.vim'

  call neobundle#load_toml(NvimDir() . '/rc/neobundle.toml')
  call neobundle#load_toml(
        \   NvimDir() . '/rc/neobundle_lazy.toml',
        \   { 'lazy': 1 }
        \ )

  if IsHomePC()
    " 開発用設定
    " 上で公開版の設定がされていても、こちらで開発用に上書きできる。
    call neobundle#local(
          \   s:vimdev_dir,
          \   { 'lazy': 1 },
          \   [ 'vim*', 'unite-*', '*.vim', '*.nvim', 'neosnippet-additional' ]
          \ )
  endif

  NeoBundleSaveCache
endif

" プラグインごとの設定
call s:source_rc('plugins.rc.vim')

call neobundle#end()

filetype plugin indent on

syntax enable

if !has('vim_starting')
  NeoBundleCheck
endif

"-----------------------------------------------------------------------------
" Encoding:
"
call s:source_rc('encoding.rc.vim')

"-----------------------------------------------------------------------------
" Search:
"
call s:source_rc('search.rc.vim')

"-----------------------------------------------------------------------------
" Edit:
"
call s:source_rc('edit.rc.vim')

"-----------------------------------------------------------------------------
" View:
"
call s:source_rc('view.rc.vim')

" vim:set foldmethod=marker:
