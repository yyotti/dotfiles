" vim:set ts=8 sts=2 sw=2 tw=0: (この行に関しては:help modelineを参照)
"##########################################################################
"# 色関係
"##########################################################################
set background=light
colorscheme solarized

"##########################################################################
"# フォント
"##########################################################################
set guifont=Ricty,12
set linespace=1

"##########################################################################
"# ウィンドウ
"##########################################################################
set columns=160
set lines=50
set cmdheight=2

" F11でフルスクリーン
nnoremap <F11> :call ToggleFullScreen()<CR>
function! ToggleFullScreen()
  if &guioptions =~# 'C'
    set guioptions-=C
    if exists('s:go_temp')
      if s:go_temp =~# 'm'
        set guioptions+=m
      endif
      if s:go_temp =~# 'T'
        set guioptions+=T
      endif
    endif
    simalt ~r
  else
    let s:go_temp = &guioptions
    set guioptions+=C
    set guioptions-=m
    set guioptions-=T
    simalt ~x
  endif
endfunction
