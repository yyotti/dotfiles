scriptencoding utf-8
"-----------------------------------------------------------------------------
" Gui:
"
augroup NvimAutocmd
  autocmd CursorHold * if exists(':rshada') | rshada | wshada | endif
  autocmd BufEnter * call s:init_neovim_qt()
augroup END


function! s:init_neovim_qt() abort "{{{
  if $NVIM_GUI ==# ''
    return
  endif

  command! -nargs=? Guifont call rpcnotify(0, 'Gui', 'SetFont', '<args>')
        \ | let g:Guifont = '<args>'

  if !exists('g:Guifont')
    set ambiwidth=double
    Guifont Courier 10 Pitch:h11
  endif
endfunction "}}}
