"-----------------------------------------------------------------------------
" Colorscheme:
"
if dein#tap('vim-hybrid') && isdirectory(dein#plugin.rtp)
  set background=dark
  colorscheme hybrid
else
  colorscheme desert
endif
