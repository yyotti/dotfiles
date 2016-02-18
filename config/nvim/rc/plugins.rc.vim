scriptencoding utf-8
"-----------------------------------------------------------------------------
" Plugins:
"
" Unite prefix
nnoremap [unite] <Nop>
xnoremap [unite] <Nop>
nmap <Leader>u [unite]
xmap <Leader>u [unite]

" VimFiler prefix
nnoremap [vimfiler] <Nop>
xnoremap [vimfiler] <Nop>
nmap <Leader>f [vimfiler]
xmap <Leader>f [vimfiler]

" Git prefix
nnoremap [git] <Nop>
nmap <Leader>g [git]

if dein#tap('deoplete.nvim') "{{{
  let g:deoplete#enable_at_startup = 1
  autocmd NvimAutocmd User dein#source#deoplete.nvim
        \ execute 'source' NvimDir() . '/rc/plugins/deoplete.rc.vim'
endif "}}}

if dein#tap('neosnippet.vim') "{{{
  autocmd NvimAutocmd User dein#source#neosnippet.vim
        \ execute 'source' NvimDir() . '/rc/plugins/neosnippet.rc.vim'
endif "}}}

if dein#tap('neosnippet-additional') "{{{
  autocmd NvimAutocmd User dein#source#neosnippet-additional
        \ call s:neosnippet_additional_on_source()
  function! s:neosnippet_additional_on_source() abort "{{{
    if !exists('g:neosnippet#snippets_directory')
      let g:neosnippet#snippets_directory = ''
    endif

    let l:snippets_dir =
          \ expand(dein#get('neosnippet-additional').path . '/snippets/')
    let l:dirs = split(g:neosnippet#snippets_directory, ',')
    for l:dir in l:dirs
      if l:dir ==# l:snippets_dir
        return
      endif
    endfor

    let g:neosnippet#snippets_directory =
          \ join(add(l:dirs, l:snippets_dir), ',')
  endfunction "}}}
endif "}}}

if dein#tap('unite.vim') "{{{
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

  autocmd NvimAutocmd User dein#source#unite.vim
        \ execute 'source' NvimDir() . '/rc/plugins/unite.rc.vim'
endif "}}}

if dein#tap('vimfiler.vim') "{{{
  nnoremap <silent> [vimfiler]e :<C-u>VimFilerBufferDir -invisible<CR>

  autocmd NvimAutocmd User dein#source#vimfiler.vim
        \ execute 'source' NvimDir() . '/rc/plugins/vimfiler.rc.vim'
endif "}}}

if dein#tap('eskk.vim') "{{{
  imap <C-j> <Plug>(eskk:toggle)
  cmap <C-j> <Plug>(eskk:toggle)

  autocmd NvimAutocmd User dein#source#eskk.vim
        \ execute 'source' NvimDir() . '/rc/plugins/eskk.rc.vim'
endif "}}}

if dein#tap('junkfile.vim') "{{{
  nnoremap <silent> [unite]j :<C-u>Unite junkfile/new junkfile<CR>
endif "}}}

if dein#tap('vim-fugitive') "{{{
  " prefix定義

  nnoremap <silent> [git]s :<C-u>Gstatus<CR>
  nnoremap <silent> [git]d :<C-u>Gvdiff<CR>

  autocmd NvimAutocmd User dein#post_source#vim-fugitive
        \ doautocmd fugitive VimEnter
endif "}}}

if dein#tap('vim-merginal') "{{{
  nnoremap <silent> [git]m :<C-u>Merginal<CR>
endif "}}}

if dein#tap('agit.vim') "{{{
  nnoremap <silent> [git]a :<C-u>Agit<CR>
  nnoremap <silent> [git]f :<C-u>AgitFile<CR>
endif "}}}

if dein#tap('vim-gitgutter') "{{{
  autocmd NvimAutocmd User dein#source#vim-gitgutter
        \ execute 'source' NvimDir() . '/rc/plugins/vim-gitgutter.rc.vim'
endif "}}}

if dein#tap('lightline.vim') "{{{
  autocmd NvimAutocmd User dein#source#lightline.vim
        \ execute 'source' NvimDir() . '/rc/plugins/lightline.rc.vim'
endif "}}}

if dein#tap('vim-ref') "{{{
  autocmd NvimAutocmd User dein#source#vim-ref
        \ execute 'source' NvimDir() . '/rc/plugins/vim-ref.rc.vim'
endif "}}}

if dein#tap('vim-easymotion') "{{{
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
endif "}}}

if dein#tap('vim-anzu') "{{{
  nmap n <Plug>(anzu-n)zvzz
  nmap N <Plug>(anzu-N)zvzz
  nmap * <Plug>(anzu-star)zvzz
  nmap # <Plug>(anzu-sharp)zvzz

  autocmd NvimAutocmd User dein#post_source#vim-anzu
        \ autocmd NvimAutocmd CursorHold,CursorHoldI,WinLeave,TabLeave *
        \   call anzu#clear_search_status()
endif "}}}

if dein#tap('vim-operator-replace') "{{{
  map R <Plug>(operator-replace)
  xmap p <Plug>(operator-replace)
endif "}}}

if dein#tap('vim-operator-surround') "{{{
  map <silent> ra <Plug>(operator-surround-append)
  map <silent> rd <Plug>(operator-surround-delete)
  map <silent> rc <Plug>(operator-surround-replace)
endif "}}}

if dein#tap('winresizer') "{{{
  " winresizerに用意されているマッピング機能を使うと遅延ロードが
  " できないので、こちらで手動マッピングしてやる。
  " winresizerをロードしたらデフォルトのマッピングがされるので、
  " ロード後にそれらのマッピングを解除する。

  if has('gui_running')
    let g:winresizer_gui_enable = 1
    nnoremap <C-w>R :<C-u>WinResizerStartResizeGUI<CR>
  endif

  let g:winresizer_vert_resize = 5
  nnoremap <C-w>r :<C-u>WinResizerStartResize<CR>

  autocmd NvimAutocmd User dein#post_source#winresizer
        \ call s:winresizer_on_post_source()

  function! s:winresizer_on_post_source() abort "{{{
    execute 'unmap' g:winresizer_start_key
    if has('gui_running')
      execute 'unmap' g:winresizer_gui_start_key
    endif
  endfunction "}}}
endif "}}}

if dein#tap('foldCC.vim') "{{{
  let g:foldCCtext_enable_autofdc_adjuster = 1
endif "}}}

if dein#tap('colorizer') "{{{
  let g:colorizer_nomap = 1
endif "}}}

if dein#tap('vim-lintexec.nvim') "{{{
  autocmd NvimAutocmd User dein#source#vim-lintexec.nvim
        \ call s:lintexec_on_source()
  function! s:lintexec_on_source() abort "{{{
    if exists('*lightline#update')
      let g:lintexec#checker_cmd = {
            \   '_': {
            \     'on_exit': function('lightline#update'),
            \   },
            \ }
    endif
  endfunction "}}}

  autocmd NvimAutocmd BufWritePost * call lintexec#run()
endif "}}}

if dein#tap('unite-quickfix') "{{{
  nnoremap <silent> [unite]q
        \ :<C-u>Unite -no-quit -no-start-insert quickfix<CR>
endif "}}}

if dein#tap('vim-quickrun') "{{{
  nmap <silent> <Leader>r <Plug>(quickrun)
endif "}}}

if dein#tap('vim-operator-flashy') "{{{
  let g:operator#flashy#flash_time = 300

  map y <Plug>(operator-flashy)
  nmap Y <Plug>(operator-flashy)$

  autocmd NvimAutocmd User dein#source#vim-operator-flashy
        \ call s:operator_flashy_on_source()

  function! s:operator_flashy_on_source() abort "{{{
    " highlight Cursor が設定されていないとエラーになるので、その対処
    let v:errmsg = ''
    silent! highlight Cursor
    if !empty(v:errmsg)
      highlight Cursor guibg=fg guifg=bg
    endif
  endfunction "}}}
endif "}}}

if dein#tap('vim-unified-diff') "{{{
  set diffexpr=unified_diff#diffexpr()
endif "}}}

if dein#tap('vim-autoupload') "{{{
  autocmd NvimAutocmd BufWinEnter *.php,*.tpl,*.css,*.js
        \ call autoupload#init(0)
  autocmd NvimAutocmd BufWritePost *.php,*.tpl,*.css,*.js
        \ call autoupload#upload(0)
endif "}}}

if dein#tap('ghcmod-vim') "{{{
  autocmd NvimAutocmd FileType haskell
        \ nnoremap <buffer> <Leader>tt :GhcModType<CR>
  autocmd NvimAutocmd FileType haskell
        \ nnoremap <buffer> <Leader>tc :GhcModTypeClear<CR>
endif "}}}

if dein#tap('unite-googletasks') "{{{
  nnoremap <silent> [unite]t
        \ :<C-u>Unite googletasks/tasklists googletasks/tasklists/new<CR>
endif "}}}

if dein#tap('matchit.zip') "{{{
  autocmd NvimAutocmd User dein#source#matchit.zip
        \ call s:matchit_on_source()
  autocmd NvimAutocmd User dein#post_source#matchit.zip
        \ execute 'source' NvimDir() . '/rc/plugins/matchit.zip.vim'

  function! s:matchit_on_source() abort "{{{
    " 起動時にデフォルトの方を無効にしているのでここで有効化する
    unlet g:loaded_matchit
  endfunction "}}}
endif "}}}

" vim:set foldmethod=marker:
