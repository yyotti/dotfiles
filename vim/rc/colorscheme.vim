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

function! s:exists_colorscheme(name) abort " {{{
  let color_files = split(globpath(&runtimepath, 'colors/*.vim'), '\n')

  for c in color_files
    let f = fnamemodify(c, ":t:r")
    echomsg string(f)
    if f ==# a:name
      return 1
    endif
  endfor

  return 0
endfunction " }}}

if s:exists_colorscheme('solarized')
  colorscheme solarized
else
  colorscheme desert
endif

" vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:
