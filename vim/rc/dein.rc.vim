let s:path = expand('$CACHE/dein')
if !dein#load_state(s:path)
  finish
endif

call dein#begin(s:path, expand('<sfile>'))

call dein#load_toml('~/.vim/dein/dein.toml', { 'lazy': 0 })
call dein#load_toml('~/.vim/dein/dein_lazy.toml', { 'lazy': 1 })
if has('nvim')
  call dein#load_toml('~/.vim/dein/dein_neo.toml', {})
endif
let s:ghq_root = expand('~/.ghq')
if isdirectory(s:ghq_root)
  call dein#local(
        \   s:ghq_root . '/github.com/yyotti',
        \   { 'frozen': 1, 'merged': 0 },
        \   [ 'vim-*', '*.vim', 'denite.nvim' ]
        \ )

  if has('nvim')
    call dein#local(
          \   s:ghq_root . '/github.com/yyotti',
          \   { 'frozen': 1, 'merged': 0 },
          \   [ '*.nvim' ]
          \ )
  endif
endif
call dein#load_toml('~/.vim/dein/dein_ft.toml')

call dein#end()
call dein#save_state()

if !has('vim_starting') && dein#check_install()
  call dein#install()
endif
