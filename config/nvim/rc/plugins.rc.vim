scriptencoding utf-8
"-----------------------------------------------------------------------------
" Plugins:
"

if neobundle#tap('deoplete.nvim') " {{{
  let g:deoplete#enable_at_startup = 1
  let neobundle#hooks.on_source =
        \   NvimDir() . '/rc/plugins/deoplete.rc.vim'

  call neobundle#untap()
endif " }}}

if neobundle#tap('neosnippet.vim') " {{{
  let neobundle#hooks.on_source =
        \   NvimDir() . '/rc/plugins/neosnippet.rc.vim'

  call neobundle#untap()
endif " }}}

" vim:set foldmethod=marker:
