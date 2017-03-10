"-----------------------------------------------------------------------------
" GUI:
"

"-----------------------------------------------------------------------------
" Fonts:
"
set ambiwidth=double

set guifontwide=Ricty\ for\ Powerline\ 11
set guifont=Ricty\ for\ Powerline\ 11

if IsWindows()
  " Windows
  set linespace=2

  if has('kaoriya')
    set ambiwidth=auto
  endif
endif

"-----------------------------------------------------------------------------
" Window:
"
if IsWindows()
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
" Options:
"
set mouse=
set mousemodel=
set nomousefocus
set mousehide

set guioptions=Mc

set guicursor&
set guicursor+=a:blinkon0
