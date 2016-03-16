"-----------------------------------------------------------------------------
" Dein:
"
call dein#begin(expand('$CACHE/dein'))

let s:toml_path = '~/.vim/rc/dein.toml'
let s:toml_lazy_path = '~/.vim/rc/dein_lazy.toml'
" TODO change to `load_state` and remove all dein-hooks-source
if dein#load_cache([ expand('<sfile>'), s:toml_path, s:toml_lazy_path ])
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
            \   [ '*.nvim' ]
            \ )
    endif
  endif

  call dein#save_cache()
endif

call dein#end()
