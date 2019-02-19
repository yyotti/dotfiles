"-----------------------------------------------------------------------------
" Neovim:
"

if exists('$HOMEBREW_PREFIX')
  let g:python_host_prog = vimrc#join_path($HOMEBREW_PREFIX, 'bin/python2')
elseif executable('/usr/bin/python')
  let g:python_host_prog = '/usr/bin/python'
endif

if exists('$HOMEBREW_PREFIX')
  let g:python_host_prog = vimrc#join_path($HOMEBREW_PREFIX, 'bin/python3')
elseif executable('/usr/bin/python3')
  let g:python_host_prog = '/usr/bin/python3'
endif

if exists('&inccommand')
  set inccommand=nosplit
endif

set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

autocmd MyAutocmd FocusGained * checktime

set mouse=
