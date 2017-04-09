"-----------------------------------------------------------------------------
" Colorscheme:
"
function! s:exists_colorscheme(name) abort "{{{
  return index(
        \   map(
        \     globpath(&runtimepath, 'colors/*.vim', 0, 1),
        \     { _, c -> fnamemodify(c, ':t:r') }
        \   ),
        \   a:name
        \ ) >= 0
endfunction "}}}

if s:exists_colorscheme('hybrid')
  set background=dark
  colorscheme hybrid
else
  colorscheme desert
endif
