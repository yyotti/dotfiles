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
  autocmd MyAutocmd User dein#source#deoplete.nvim
        \ source ~/.vim/rc/plugins/deoplete.rc.vim
endif "}}}

if dein#tap('neocomplete.vim') "{{{
  let g:neocomplete#enable_at_startup = 1
  autocmd MyAutocmd User dein#source#neocomplete.vim
        \ source ~/.vim/rc/plugins/neocomplete.rc.vim
endif "}}}

if dein#tap('neosnippet.vim') "{{{
  autocmd MyAutocmd User dein#source#neosnippet.vim
        \ source ~/.vim/rc/plugins/neosnippet.rc.vim
endif "}}}

if dein#tap('neosnippet-additional') "{{{
  autocmd MyAutocmd User dein#source#neosnippet-additional
        \ call s:neosnippet_additional_on_source()
  function! s:neosnippet_additional_on_source() abort "{{{
    if !exists('g:neosnippet#snippets_directory')
      let g:neosnippet#snippets_directory = ''
    endif

    let snippets_dir =
          \ expand(dein#get('neosnippet-additional').path . '/snippets/')
    let dirs = split(g:neosnippet#snippets_directory, ',')
    for dir in dirs
      if dir ==# snippets_dir
        return
      endif
    endfor

    let g:neosnippet#snippets_directory =
          \ join(add(dirs, snippets_dir), ',')
  endfunction "}}}
endif "}}}

if dein#tap('unite.vim') "{{{
  " buffer + mru
  nnoremap <silent> [unite]b :<C-u>Unite buffer file_mru<CR>
  " bookmarks
  nnoremap <silent> [unite]m :<C-u>Unite bookmark<CR>
  " file
  nnoremap <silent> [unite]f
        \ :<C-u>Unite -buffer-name=files -no-split -multi-line -unique -silent
        \   `finddir('.git', ';') !=# '' ? 'file_rec/git' : ''`
        \     buffer_tab:- file file/new<CR>
  " unite-line
  nnoremap <silent> [unite]l :<C-u>Unite line<CR>
  " grep
  nnoremap <silent> [unite]g
        \ :<C-u>Unite grep -buffer-name=grep -no-start-insert -no-empty<CR>
  " grep resume
  nnoremap <silent> [unite]r
        \ :<C-u>UniteResume -buffer-name=grep
        \   -no-start-insert -no-empty grep<CR>

  let g:unite_force_overwrite_statusline = 0

  autocmd MyAutocmd User dein#source#unite.vim
        \ source ~/.vim/rc/plugins/unite.rc.vim
endif "}}}

if dein#tap('vimfiler.vim') "{{{
  nnoremap <silent> [vimfiler]e :<C-u>VimFilerBufferDir -invisible<CR>

  autocmd MyAutocmd User dein#source#vimfiler.vim
        \ source ~/.vim/rc/plugins/vimfiler.rc.vim
endif "}}}

if dein#tap('eskk.vim') "{{{
  imap <C-j> <Plug>(eskk:toggle)
  cmap <C-j> <Plug>(eskk:toggle)

  autocmd MyAutocmd User dein#source#eskk.vim
        \ source ~/.vim/rc/plugins/eskk.rc.vim
endif "}}}

if dein#tap('junkfile.vim') "{{{
  nnoremap <silent> [unite]j :<C-u>Unite junkfile/new junkfile<CR>
endif "}}}

if dein#tap('vim-fugitive') "{{{
  nnoremap <silent> [git]s :<C-u>Gstatus<CR>
  nnoremap <silent> [git]d :<C-u>Gvdiff<CR>

  autocmd MyAutocmd User dein#post_source#vim-fugitive
        \ doautocmd fugitive VimEnter
endif "}}}

if dein#tap('agit.vim') "{{{
  nnoremap <silent> [git]a :<C-u>Agit<CR>
  nnoremap <silent> [git]f :<C-u>AgitFile<CR>
endif "}}}

if dein#tap('vim-gitgutter') "{{{
  autocmd MyAutocmd User dein#source#vim-gitgutter
        \ source ~/.vim/rc/plugins/vim-gitgutter.rc.vim
endif "}}}

if dein#tap('vim-ref') "{{{
  nmap K <Plug>(ref-keyword)
  autocmd MyAutocmd User dein#source#vim-ref
        \ source ~/.vim/rc/plugins/vim-ref.rc.vim
endif "}}}

if dein#tap('vim-easymotion') "{{{
  let g:EasyMotion_smartcase = 1
  let g:EasyMotion_enter_jump_first = 1
  let g:EasyMotion_space_jump_first = 1
  let g:EasyMotion_startofline = 0
  let g:EasyMotion_verbose = 0

  map ' <Plug>(easymotion-prefix)

  map f <Plug>(easymotion-fl)
  map t <Plug>(easymotion-tl)
  map F <Plug>(easymotion-Fl)
  map T <Plug>(easymotion-Tl)

  map ; <Plug>(easymotion-next)
  map , <Plug>(easymotion-prev)

  map 'f <Plug>(easymotion-fln)
  map 't <Plug>(easymotion-tln)
  map 'F <Plug>(easymotion-Fln)
  map 'T <Plug>(easymotion-Tln)

  map 's <Plug>(easymotion-sn)
endif "}}}

if dein#tap('vim-anzu') "{{{
  nmap n <Plug>(anzu-n)zvzz
  nmap N <Plug>(anzu-N)zvzz
  nmap * <Plug>(anzu-star)zvzz
  nmap # <Plug>(anzu-sharp)zvzz

  autocmd MyAutocmd User dein#post_source#vim-anzu
        \ autocmd MyAutocmd CursorHold,CursorHoldI,WinLeave,TabLeave *
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
  if has('gui_running')
    let g:winresizer_gui_enable = 1
    nnoremap <C-w>R :<C-u>WinResizerStartResizeGUI<CR>
  endif

  let g:winresizer_vert_resize = 5
  nnoremap <C-w>r :<C-u>WinResizerStartResize<CR>

  autocmd MyAutocmd User dein#post_source#winresizer
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

if dein#tap('vim-lintexec.nvim') && has('nvim') "{{{
  autocmd MyAutocmd User dein#source#vim-lintexec.nvim
        \ call s:lintexec_on_source()
  function! s:lintexec_on_source() abort "{{{
    if exists('*lightline#update')
      let g:lintexec#checker_cmd = {
            \   '_': {
            \     'on_exit': function('lightline#update'),
            \   },
            \ }
    endif

    " Use vim-vimlint
    if dein#tap('vim-vimlparser') && dein#tap('vim-vimlint')
      let vimlparser = fnamemodify(dein#get('vim-vimlparser').rtp, ':p')
      let vimlint = fnamemodify(dein#get('vim-vimlint').rtp, ':p')
      if !exists('g:lintexec#checker_cmd')
        let g:lintexec#checker_cmd = {}
      endif
      if !has_key(g:lintexec#checker_cmd, 'vim')
        let g:lintexec#checker_cmd.vim = {}
      endif
      let g:lintexec#checker_cmd.vim.exec =
            \ expand('~/.vim/script/vim-vimlint.sh')
      let g:lintexec#checker_cmd.vim.args = [
            \   vimlparser, vimlint, tempname()
            \ ]
      let g:lintexec#checker_cmd.vim.errfmt =
            \ '%f:%l:%c:%trror: %m,%f:%l:%c:%tarning: %m,%f:%l:%c:%m'
    endif
  endfunction "}}}

  autocmd MyAutocmd BufWritePost * call lintexec#run()
endif "}}}

if dein#tap('unite-quickfix') "{{{
  nnoremap <silent> [unite]q
        \ :<C-u>Unite -no-quit -no-start-insert quickfix<CR>
endif "}}}

if dein#tap('vim-quickrun') "{{{
  nmap <silent> <Leader>r <Plug>(quickrun)
endif "}}}

if dein#tap('vim-operator-flashy') "{{{
  let g:operator#flashy#flash_time = exists('$NVIM_GUI') ? 100 : 300

  map y <Plug>(operator-flashy)
  nmap Y <Plug>(operator-flashy)$

  autocmd MyAutocmd User dein#source#vim-operator-flashy
        \ call s:operator_flashy_on_source()

  function! s:operator_flashy_on_source() abort "{{{
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
  autocmd MyAutocmd BufWinEnter *.php,*.tpl,*.css,*.js
        \ call autoupload#init(0)
  autocmd MyAutocmd BufWritePost *.php,*.tpl,*.css,*.js
        \ call autoupload#upload(0)
endif "}}}

if dein#tap('ghcmod-vim') "{{{
  autocmd MyAutocmd FileType haskell
        \ nnoremap <buffer> <Leader>tt :GhcModType<CR>
  autocmd MyAutocmd FileType haskell
        \ nnoremap <buffer> <Leader>tc :GhcModTypeClear<CR>
endif "}}}

if dein#tap('matchit.zip') "{{{
  autocmd MyAutocmd User dein#source#matchit.zip
        \ call s:matchit_on_source()
  autocmd MyAutocmd User dein#post_source#matchit.zip
        \ source ~/.vim/rc/plugins/matchit.zip.rc.vim

  function! s:matchit_on_source() abort "{{{
    unlet g:loaded_matchit
  endfunction "}}}
endif "}}}

if dein#tap('caw.vim') "{{{
  nmap gc <Plug>(caw:prefix)
  xmap gc <Plug>(caw:prefix)
endif "}}}

if dein#tap('vim-watchdogs') "{{{
  autocmd MyAutocmd User dein#source#vim-watchdogs
        \ source ~/.vim/rc/plugins/vim-watchdogs.rc.vim
  autocmd MyAutocmd User dein#post_source#vim-watchdogs
        \ call watchdogs#setup(g:quickrun_config)
endif "}}}

if dein#tap('vim-qfstatusline') "{{{
  autocmd MyAutocmd User dein#source#vim-qfstatusline
        \ source ~/.vim/rc/plugins/vim-qfstatusline.rc.vim
  autocmd MyAutocmd User dein#post_source#vim-qfstatusline
        \ let g:Qfstatusline#UpdateCmd =
        \   exists('*lightline#update') ?
        \     function('lightline#update') : function('qfstatusline#Update')

endif "}}}

if dein#tap('vim-qfsigns') "{{{
  autocmd MyAutocmd User dein#source#vim-qfsigns
        \ source ~/.vim/rc/plugins/vim-qfsigns.rc.vim
endif "}}}

if dein#tap('vim-gista') " {{{
  let g:gista#github_user = 'yyotti'
  let g:gista#post_private = 1
  let g:gista#directory = expand('$CACHE/gista')

  nnoremap [unite]a :<C-u>Unite gista<CR>
endif " }}}

if dein#tap('vim-themis') "{{{
  source ~/.vim/rc/plugins/vim-themis.rc.vim
endif "}}}
