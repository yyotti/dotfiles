"-----------------------------------------------------------------------------
" Dein:
"
let g:dein#install_progress_type = 'title'

let s:path = expand('$CACHE/dein')
if !dein#load_state(s:path)
  finish
endif

let s:toml_path = '~/.vim/rc/dein.toml'
let s:toml_lazy_path = '~/.vim/rc/dein_lazy.toml'

call dein#begin(s:path, [ expand('<sfile>'), s:toml_path, s:toml_lazy_path ])

call dein#load_toml(s:toml_path, { 'lazy': 0 })
call dein#load_toml(s:toml_lazy_path, { 'lazy': 1 })

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
