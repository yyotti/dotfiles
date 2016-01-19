scriptencoding utf-8
"-----------------------------------------------------------------------------
" Plugins:
"

if neobundle#tap('deoplete.nvim') "{{{
  let g:deoplete#enable_at_startup = 1
  let neobundle#hooks.on_source =
        \ NvimDir() . '/rc/plugins/deoplete.rc.vim'

  call neobundle#untap()
endif "}}}

if neobundle#tap('neosnippet.vim') "{{{
  let neobundle#hooks.on_source =
        \ NvimDir() . '/rc/plugins/neosnippet.rc.vim'

  call neobundle#untap()
endif "}}}

if neobundle#tap('neosnippet-additional') "{{{
  function! neobundle#hooks.on_source(bundle) abort "{{{
    if !exists('g:neosnippet#snippets_directory')
      let g:neosnippet#snippets_directory = ''
    endif

    let snippets_dir = expand(a:bundle.path . '/snippets/')
    let dirs = split(g:neosnippet#snippets_directory, ',')
    for dir in dirs
      if dir ==# snippets_dir
        return
      endif
    endfor

    echomsg string(snippets_dir)
    let g:neosnippet#snippets_directory = join(add(dirs, snippets_dir), ',')
  endfunction "}}}

  call neobundle#untap()
endif "}}}

if neobundle#tap('unite.vim') "{{{
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
endif "}}}

if neobundle#tap('vimfiler.vim') "{{{
  nnoremap [vimfiler] <Nop>
  xnoremap [vimfiler] <Nop>
  nmap <Leader>f [vimfiler]
  xmap <Leader>f [vimfiler]

  nnoremap <silent> [vimfiler]e :<C-u>VimFilerBufferDir -invisible<CR>

  let neobundle#hooks.on_source =
        \ NvimDir() . '/rc/plugins/vimfiler.rc.vim'

  call neobundle#untap()
endif "}}}

if neobundle#tap('eskk.vim') "{{{
  imap <C-j> <Plug>(eskk:toggle)
  cmap <C-j> <Plug>(eskk:toggle)

  let neobundle#hooks.on_source =
        \ NvimDir() . '/rc/plugins/eskk.rc.vim'

  call neobundle#untap()
endif "}}}

if neobundle#tap('junkfile.vim') "{{{
  nnoremap <silent> [unite]j :<C-u>Unite junkfile/new junkfile<CR>

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-fugitive') "{{{
  " prefix定義
  nnoremap [git] <Nop>
  nmap <Leader>g [git]

  nnoremap <silent> [git]s :<C-u>Gstatus<CR>
  nnoremap <silent> [git]d :<C-u>Gvdiff<CR>

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-merginal') "{{{
  nnoremap <silent> [git]m :<C-u>Merginal<CR>

  " @vimlint(EVL103, 1, a:bundle)
  function! neobundle#hooks.on_post_source(bundle) abort "{{{
    doautocmd User Fugitive
  endfunction "}}}
  " @vimlint(EVL103, 0, a:bundle)

  call neobundle#untap()
endif "}}}

if neobundle#tap('agit.vim') "{{{
  nnoremap <silent> [git]a :<C-u>Agit<CR>
  nnoremap <silent> [git]f :<C-u>AgitFile<CR>

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-gitgutter') "{{{
  let neobundle#hooks.on_source =
        \ NvimDir() . '/rc/plugins/vim-gitgutter.rc.vim'

  call neobundle#untap()
endif "}}}

if neobundle#tap('lightline.vim') "{{{
  let neobundle#hooks.on_source =
        \ NvimDir() . '/rc/plugins/lightline.rc.vim'

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-ref') "{{{
  let neobundle#hooks.on_source =
        \ NvimDir() . '/rc/plugins/vim-ref.rc.vim'

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-easymotion') "{{{
  let g:EasyMotion_smartcase = 1
  let g:EasyMotion_enter_jump_first = 1
  let g:EasyMotion_space_jump_first = 1
  let g:EasyMotion_startofline = 0

  " easymotionのプレフィックスは基本的に'とする
  map ' <Plug>(easymotion-prefix)

  " fとtのマッピングを置換する
  map f <Plug>(easymotion-fl)
  map t <Plug>(easymotion-tl)
  map F <Plug>(easymotion-Fl)
  map T <Plug>(easymotion-Tl)
  " ;/,を置換
  map ; <Plug>(easymotion-next)
  map , <Plug>(easymotion-prev)

  " ' + f/t/F/T で複数文字のやつにする
  map 'f <Plug>(easymotion-fln)
  map 't <Plug>(easymotion-tln)
  map 'F <Plug>(easymotion-Fln)
  map 'T <Plug>(easymotion-Tln)

  " 'sは複数個のやつにマッピングする
  " これがあるとw/e系がほとんど不要になってしまうが。
  map 's <Plug>(easymotion-sn)

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-anzu') "{{{
  nmap n <Plug>(anzu-n)zvzz
  nmap N <Plug>(anzu-N)zvzz
  nmap * <Plug>(anzu-star)zvzz
  nmap # <Plug>(anzu-sharp)zvzz

  " @vimlint(EVL103, 1, a:bundle)
  function! neobundle#hooks.on_source(bundle) abort "{{{
    autocmd NvimAutocmd CursorHold,CursorHoldI,WinLeave,TabLeave *
          \ call anzu#clear_search_status()
  endfunction "}}}
  " @vimlint(EVL103, 0, a:bundle)

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-operator-replace') "{{{
  map R <Plug>(operator-replace)
  xmap p <Plug>(operator-replace)

  call neobundle#untap()
endif "}}}

" vim:set foldmethod=marker:
