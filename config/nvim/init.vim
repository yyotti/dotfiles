scriptencoding utf-8

"-----------------------------------------------------------------------------
" Initialize_for_nvim:
"
let s:nvim_dir = fnamemodify(expand('<sfile>'), ':h')
let s:is_windows = has('win16') || has('win32') || has('win64') || has('win95')
let s:is_cygwin = has('win32unix')
let s:is_unix = has('unix')

function! s:source_rc(path) abort "{{{
  execute 'source' fnameescape(s:nvim_dir . '/rc/' . a:path)
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

call s:source_rc('init.rc.vim')

" プラグインインストール/設定
call dein#begin(expand('$CACHE/dein'))

call dein#add('Shougo/dein.vim', { 'rtp': '' })

" FIXME deinがtomlをサポートしたら書き換える
call s:source_rc('dein.rc.vim')
call s:source_rc('dein_lazy.rc.vim')

" 開発用設定
for s:file in glob('~/.dev_plugins/*_dev.vim', 0, 1)
  execute 'source' fnameescape(expand(s:file))
  unlet s:file
endfor

" プラグインごとの設定
call s:source_rc('plugins.rc.vim')

call dein#end()

filetype plugin indent on

syntax enable

if !has('vim_starting')
  call dein#check_install()
endif

" vim:set foldmethod=marker:
