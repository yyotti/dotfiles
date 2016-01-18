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

if neobundle#tap('unite.vim') " {{{
  nnoremap [unite] <Nop>
  xnoremap [unite] <Nop>
  nmap <Leader>u [unite]
  xmap <Leader>u [unite]

  " buffer + mru
  nnoremap <silent> [unite]b :<C-u>Unite buffer file_mru<CR>
  " only mru
  nnoremap <silent> [unite]u :<C-u>Unite file_mru<CR>
  " bookmarks
  nnoremap <silent> [unite]m :<C-u>Unite bookmark<CR>
  " unite-line
  nnoremap <silent> [unite]l :<C-u>Unite line<CR>
  " grep
  nnoremap <silent> [unite]g
        \ :<C-u>Unite grep -buffer-name=grep
        \   -no-start-insert -auto-preview -no-empty<CR>
  " grep resume
  nnoremap <silent> [unite]r
        \ :<C-u>UniteResume -buffer-name=grep
        \   -no-start-insert -auto-preview -no-empty grep<CR>

  let g:unite_force_overwrite_statusline = 0

  let neobundle#hooks.on_source =
        \ NvimDir() . '/rc/plugins/unite.rc.vim'

  call neobundle#untap()
endif " }}}

if neobundle#tap('vimfiler.vim') " {{{
  nnoremap [vimfiler] <Nop>
  xnoremap [vimfiler] <Nop>
  nmap <Leader>f [vimfiler]
  xmap <Leader>f [vimfiler]

  nnoremap <silent> [vimfiler]e :<C-u>VimFilerBufferDir -invisible<CR>

  let neobundle#hooks.on_source =
        \ NvimDir() . '/rc/plugins/vimfiler.rc.vim'

  call neobundle#untap()
endif " }}}

if neobundle#tap('eskk.vim') " {{{
  imap <C-j> <Plug>(eskk:toggle)
  cmap <C-j> <Plug>(eskk:toggle)

  let neobundle#hooks.on_source =
        \ NvimDir() . '/rc/plugins/eskk.rc.vim'

  call neobundle#untap()
endif " }}}

if neobundle#tap('junkfile.vim') " {{{
  nnoremap <silent> [unite]j :<C-u>Unite junkfile/new junkfile<CR>

  call neobundle#untap()
endif " }}}

" vim:set foldmethod=marker:
