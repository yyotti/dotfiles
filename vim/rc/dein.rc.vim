"-----------------------------------------------------------------------------
" Dein:
"
let g:dein#install_progress_type = 'title'

let s:path = expand('$CACHE/dein')
if !dein#load_state(s:path)
  finish
endif

call dein#begin(s:path, expand('<sfile>'))

call dein#load_toml('~/.vim/rc/dein.toml', { 'lazy': 0 })
call dein#load_toml('~/.vim/rc/dein_lazy.toml', { 'lazy': 1 })

if IsHomePC()
  " Load develop version
  call dein#local(
        \   VimDevDir(),
        \   { 'frozen': 1 },
        \   [ 'vim*', 'unite-*', '*.vim', 'neosnippet-additional' ]
        \ )

  if has('nvim')
    " Only for neovim
    call dein#local(
          \   VimDevDir(),
          \   { 'frozen': 1 },
          \   [ 'nvim-*', '*.nvim' ]
          \ )
  endif
endif

call dein#end()
call dein#save_state()

if !has('vim_starting') && dein#check_install()
  call dein#install()
endif
