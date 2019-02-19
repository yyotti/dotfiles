"-----------------------------------------------------------------------------
" Colorscheme:
"
if dein#tap('vim-hybrid') && !dein#check_install(g:dein#name)
  set background=dark
  colorscheme hybrid
else
  colorscheme desert
endif
