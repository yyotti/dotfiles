"-----------------------------------------------------------------------------
" Neovim:
"
if has('vim_starting') && argc() == 0
  syntax off
endif

if exists('$HOMEBREW_PREFIX') && executable(expand('$HOMEBREW_PREFIX') . '/bin/python2')
  let g:python_host_prog = expand('$HOMEBREW_PREFIX') . '/bin/python2'
else
  let g:python_host_prog = '/usr/bin/python'
endif

if exists('$HOMEBREW_PREFIX') && executable(expand('$HOMEBREW_PREFIX') . '/bin/python3')
  let g:python3_host_prog = expand('$HOMEBREW_PREFIX') . '/bin/python3'
else
  let g:python3_host_prog = '/usr/bin/python3'
endif

if exists('&inccommand')
  set inccommand=nosplit
endif

set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

set mouse=

autocmd MyAutocmd CursorHold * if exists(':rshada') | rshada | wshada | endif
