"-----------------------------------------------------------------------------
" Colorscheme:
"
if dein#tap('vim-hybrid') && isdirectory(g:dein#plugin.rtp)
  set background=dark
  colorscheme hybrid
else
  colorscheme desert
endif
