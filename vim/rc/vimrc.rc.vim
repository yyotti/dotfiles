"-----------------------------------------------------------------------------
" Initialize:
"
if !has('nvim') && v:version < 800
  finish
endif

let s:defaults_vim = expand('$VIMRUNTIME/defaults.vim')
if !has('nvim') && filereadable(s:defaults_vim)
  unlet! g:skip_defaults_vim
  execute 'source' s:defaults_vim
endif

" Delete all my autocmd
augroup MyAutocmd
  autocmd!
augroup END

let $_VIMDIR = fnamemodify($MYVIMRC, ':h')
if $XDG_CACHE_HOME ==# ''
  let $_CACHE = fnamemodify(expand('$HOME/.cache/vim', ':p'))
else
  let $_CACHE = fnamemodify(expand('$XDG_CACHE_HOME/vim'), ':p')
endif

if !isdirectory($_CACHE)
  call mkdir($_CACHE, 'p')
endif

if has('vim_starting')
  execute 'source' expand('$_VIMDIR/rc/init.rc.vim')
endif

"-----------------------------------------------------------------------------
" Plugin Settings:
"
execute 'source' expand('$_VIMDIR/rc/vim-plug.rc.vim')

"-----------------------------------------------------------------------------
" Filetypes:
"
execute 'source' expand('$_VIMDIR/rc/filetypes.rc.vim')

"-----------------------------------------------------------------------------
" Options:
"
execute 'source' expand('$_VIMDIR/rc/encoding.rc.vim')
execute 'source' expand('$_VIMDIR/rc/options.rc.vim')
execute 'source' expand('$_VIMDIR/rc/mappings.rc.vim')



if has('nvim')
  execute 'source' expand('$_VIMDIR/rc/neovim.rc.vim')
endif

execute 'source' expand('$_VIMDIR/rc/unix.rc.vim')

"-----------------------------------------------------------------------------
" Colorscheme:
"
execute 'source' expand('$_VIMDIR/rc/colorscheme.rc.vim')

"-----------------------------------------------------------------------------
" Local Settings:
"
let s:local_vimrc = fnamemodify(expand('$HOME/.vimrc.local'), ':p')
if filereadable(s:local_vimrc)
  execute 'source' s:local_vimrc
endif

set helplang&
set helplang=ja,en
set secure
