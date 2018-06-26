"-----------------------------------------------------------------------------
" Neovim:
"
if has('vim_starting') && argc() == 0
  syntax off
endif

let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

if exists('&inccommand')
  set inccommand=nosplit
endif

set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

set mouse=

autocmd MyAutocmd CursorHold * if exists(':rshada') | rshada | wshada | endif
