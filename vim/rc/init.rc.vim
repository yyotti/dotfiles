"-----------------------------------------------------------------------------
" Initialize:
"

let s:is_windows = has('win32') || has('win64')

function! IsWindows() abort "{{{
  return s:is_windows
endfunction "}}}

if has('vim_starting') && &encoding !=# 'utf-8'
  if IsWindows() && !has('gui_running')
    " CUI in Windows (Command prompt)
    set encoding=cp932
  else
    set encoding=utf-8
  endif
endif

" Build encodings
let &fileencodings = join([
      \   'ucs-bom', 'iso-2022-jp-3', 'utf-8', 'euc-jp', 'cp932'
      \ ])

" Setting of terminal encoding
if !has('gui_running') && IsWindows()
  set termencoding=cp932
endif

if has('multi_byte_ime')
  set iminsert=0
  set imsearch=0
endif

" Use English interface
language message C

" Use <Space> for <Leader>
let g:mapleader = "\<Space>"
" Use ',' for <LocalLeader>
let g:maplocalleader = ','

" Disable mappings for some plugins
nnoremap , <Nop>
xnoremap , <Nop>
nnoremap m <Nop>

if IsWindows()
  " Change path separator
  set shellslash
endif

" Create cache directory
let $CACHE = expand('~/.cache')
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif

" Load dein.vim
if &runtimepath !~# '/dein.vim'
  let s:dein_dir = expand('$CACHE/dein') . '/repos/github.com/Shougo/dein.vim'
  if !isdirectory(s:dein_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
  endif

  execute 'set runtimepath^='
        \   . substitute(fnamemodify(s:dein_dir, ':p'), '/$', '', '')
  unlet s:dein_dir
endif

" Disable packpath
set packpath=

" Disable default plugins {{{
let g:loaded_2html_plugin = 1
let g:loaded_logiPat = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_man = 1
let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_rrhelper = 1
let g:loaded_shada_plugin = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zipPlugin = 1
" }}}
