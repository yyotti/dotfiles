"-----------------------------------------------------------------------------
" Initialize:
"

language message C

" Use <Space> for <Leader>
let g:mapleader = "\<Space>"
" Use ',' for <LocalLeader>
let g:maplocalleader = ','

" Disable mappings for some plugins
nnoremap ,  <Nop>
xnoremap ,  <Nop>

if IsWindows()
  " Change path separator
  set shellslash
endif

let $CACHE = expand('~/.cache')
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif

" Delete all my autocmd
augroup MyAutocmd
  autocmd!
augroup END

" Load dein.vim
if &runtimepath !~# '/dein.vim'
  let s:dein_dir = expand('$CACHE/dein') . '/repos/github.com/Shougo/dein.vim'
  if !isdirectory(s:dein_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_dir, ':p')
  unlet s:dein_dir
endif

" Disable packpath
set packpath=

" Disable default plugins {{{
let g:loaded_2html_plugin = 1
" let g:loaded_LogiPat = 1
" let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logiPat = 1
let g:loaded_man = 1
let g:loaded_matchit = 1
" let g:loaded_matchparen = 1
" let g:loaded_netrw = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_rrhelper = 1
let g:loaded_shada_plugin = 1
let g:loaded_spellfile_plugin = 1
" let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_tutor_mode_plugin = 1
" let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
" let g:loaded_zip = 1
let g:loaded_zipPlugin = 1
" }}}
