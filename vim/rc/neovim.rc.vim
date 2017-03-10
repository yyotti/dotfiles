"-----------------------------------------------------------------------------
" Neovim:
"
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

if exists('&inccommand')
  set inccommand=nosplit
endif

let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

tnoremap <ESC> <C-\><C-n>

set mouse=

autocmd MyAutocmd CursorHold * if exists(':rshada') | rshada | wshada | endif
