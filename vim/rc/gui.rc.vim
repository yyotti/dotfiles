"-----------------------------------------------------------------------------
" GUI:
"

"-----------------------------------------------------------------------------
" Fonts:
"
set ambiwidth=double

if !IsWindows()
  set guifontwide=Ricty\ for\ Powerline\ 11
  set guifont=Ricty\ for\ Powerline\ 11
endif

if has('win32') || has('win64')
  " Windows
  set linespace=2
  if has('patch-7.4.394')
    set renderoptions=type:directx
  endif

  if has('kaoriya')
    set ambiwidth=auto
  endif
endif

"-----------------------------------------------------------------------------
" Window:
"
if has('win32') || has('win64')
  set columns=220
  set lines=55
else
  if &columns < 180
    set columns=180
  endif
  if &lines < 55
    set lines=55
  endif
endif

"-----------------------------------------------------------------------------
" Menu:
"
set guioptions=Mc

"-----------------------------------------------------------------------------
" View:
"
set guicursor&
set guicursor+=a:blinkon0
