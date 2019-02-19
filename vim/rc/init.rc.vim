"---------------------------------------------------------------------------
" Initialize:
"
if has('vim_starting') && &encoding !=# 'utf-8'
  set encoding=utf-8
endif

" Build encodings
let &fileencodings = join([
      \   'ucs-bom', 'iso-2022-jp-3', 'utf-8', 'euc-jp', 'cp932'
      \ ])

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
nnoremap ; <Nop>
nnoremap "\<Space>" <Nop>
nnoremap , <Nop>

if !isdirectory($_CACHE)
  call mkdir($_CACHE, 'p')
endif

" Load dein
if &runtimepath !~# '/dein.vim'
  let s:dein_dir = vimrc#join_path(
        \   $_CACHE,
        \   'dein/repos/github.com/Shougo/dein.vim'
        \ )
  if !isdirectory(s:dein_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
  endif

  execute 'set runtimepath^=' . substitute(
        \   fnamemodify(s:dein_dir, ':p') , '/$', '', ''
        \ )
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
"}}}
