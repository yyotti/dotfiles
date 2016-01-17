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

" vim:set foldmethod=marker:
