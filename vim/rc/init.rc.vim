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
nnoremap <Space> <Nop>
nnoremap , <Nop>

" Download vim-plug
let s:plug_vim = fnamemodify(expand('$_VIMDIR/autoload/plug.vim'), ':p')
if empty(glob(s:plug_vim))
  execute 'silent !curl -fLo' s:plug_vim '--create-dirs'
        \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
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
