"-----------------------------------------------------------------------------
" Colorscheme:
"
if has_key(get(g:, 'plugs', {}), 'vim-hybrid') &&
            \ isdirectory(g:plugs['vim-hybrid'].dir)
  set background=dark
  colorscheme hybrid
else
  colorscheme desert
endif
