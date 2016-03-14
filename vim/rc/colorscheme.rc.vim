"-----------------------------------------------------------------------------
" Colorscheme:
"
autocmd MyAutocmd ColorScheme *
      \ call <SID>change_colorscheme(expand('<amatch>'))
function! s:change_colorscheme(cs_name) abort "{{{
  if a:cs_name ==# 'hybrid'
    highlight clear CursorLine
  endif
endfunction "}}}

function! s:exists_colorscheme(name) abort "{{{
  let l:color_files = split(globpath(&runtimepath, 'colors/*.vim'), '\n')
  for l:c in l:color_files
    let l:f = fnamemodify(l:c, ':t:r')
    if l:f ==# a:name
      return 1
    endif
  endfor

  return 0
endfunction "}}}

if has('gui_running') && s:exists_colorscheme('solarized')
  set background=light
  colorscheme solarized
elseif s:exists_colorscheme('hybrid')
  set background=dark
  colorscheme hybrid
else
  colorscheme desert
endif
