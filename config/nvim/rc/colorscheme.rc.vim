scriptencoding utf-8
"-----------------------------------------------------------------------------
" Colorscheme:
"
if !has('gui_running')
  set t_ut=
  set t_Co=256
endif

autocmd NvimAutocmd ColorScheme *
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

if s:exists_colorscheme('hybrid')
  colorscheme hybrid
  set background=dark
elseif s:exists_colorscheme('solarized')
  colorscheme solarized
  if has('gui_running')
    set background=light
  else
    set background=dark
  endif
else
  colorscheme desert
endif

if exists('$NVIM_GUI')
  " TODO colorschemeやbackgroundが設定されるとウィンドウサイズが戻ってしまう
  "      ようなので、ここで設定してやる
  SetWinsizeDefault
endif

" vim:set foldmethod=marker:
