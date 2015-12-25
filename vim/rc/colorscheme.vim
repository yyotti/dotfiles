scriptencoding utf-8
"--------------------------------------------------------------------------------
" Colorscheme:
"
if !has('gui_running')
  set t_ut=
  set t_Co=256
  set background=dark
else
  set background=light
endif

if neobundle#is_sourced('vim-colors-solarized')
  colorscheme solarized
else
  colorscheme desert
endif

" vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:
