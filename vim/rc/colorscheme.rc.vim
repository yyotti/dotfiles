"-----------------------------------------------------------------------------
" Colorscheme:
"
function! s:exists_colorscheme(name) abort "{{{
  let color_files = split(globpath(&runtimepath, 'colors/*.vim'), '\n')
  for c in color_files
    let f = fnamemodify(c, ':t:r')
    if f ==# a:name
      return 1
    endif
  endfor

  return 0
endfunction "}}}

if s:exists_colorscheme('hybrid')
  set background=dark
  colorscheme hybrid
else
  colorscheme desert
endif
