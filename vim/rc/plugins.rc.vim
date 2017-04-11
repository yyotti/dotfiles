"-----------------------------------------------------------------------------
" Plugins:
"

if !has('timers')
  autocmd MyAutocmd VimEnter *
        \   call packages#filetype_on()
        \ | echomsg 'Vim version is old. You cannot use plugins.'
  finish
endif

set packpath=~/.vim

" Initial settings "{{{

" Vim
let g:vimsyntax_noerror = 1

" Bash
let g:is_bash = 1

" python.vim
let g:python_highlight_all = 1

" markdown colors
" http://mattn.kaoriya.net/software/vim/20140523124903.htm
let g:markdown_fenced_languages = [
      \   'css',
      \   'javascript',
      \   'js=javascript',
      \   'json=javascript',
      \   'xml',
      \   'vim',
      \   'php',
      \ ]

" Folding
let g:xml_syntax_folding = 1

" Update filetype
autocmd MyAutocmd BufWritePost * nested
      \ if &l:filetype ==# '' || exists('b:ftdetect') |
      \   unlet! b:ftdetect |
      \   filetype detect |
      \ endif
"}}}

if !packages#begin()
  finish
endif

autocmd plugin-packages User post-plugins-loaded nested
      \ source ~/.vim/rc/colorscheme.rc.vim

let s:plugin = packages#add('tyru/caw.vim', {
      \   'depends': [ 'vim-operator-user', 'vim-repeat' ],
      \ })
function! s:plugin.pre_add() abort "{{{
  function! InitCaw() abort "{{{
    if !&l:modifiable
      silent! nunmap <buffer> gc
      silent! xunmap <buffer> gc
      silent! nunmap <buffer> gcc
      silent! xunmap <buffer> gcc
    else
      nmap <buffer> gc <Plug>(caw:prefix)
      xmap <buffer> gc <Plug>(caw:prefix)
      nmap <buffer> gcc <Plug>(caw:hatpos:toggle)
      xmap <buffer> gcc <Plug>(caw:hatpos:toggle)
    endif

  endfunction "}}}

  autocmd MyAutocmd FileType * call InitCaw()

  let g:caw_operator_keymappings = 1
endfunction "}}}
unlet s:plugin

call packages#add('kana/vim-operator-user')

call packages#add('tpope/vim-repeat')

call packages#add('w0ng/vim-hybrid')

let s:plugin = packages#add('tpope/vim-fugitive')
function! s:plugin.pre_add() abort "{{{
  nnoremap <silent> <Leader>gs :<C-u>Gstatus<CR>
  nnoremap <silent> <Leader>gd :<C-u>Gvdiff<CR>
endfunction "}}}
function! s:plugin.post_add() abort "{{{
  doautocmd fugitive VimEnter
  if argc() > 0
    doautocmd fugitive BufReadPost
  endif
endfunction "}}}
unlet s:plugin

call packages#add('itchyny/lightline.vim', {
      \   'post_add': '~/.vim/rc/plugins/lightline.rc.vim',
      \ })

call packages#add('itchyny/vim-parenmatch', {
      \   'condition': v:version == 704 && has('patch786')
      \                 || v:version >= 705 || has('nvim'),
      \ })

let s:plugin = packages#add('elzr/vim-json')
function! s:plugin.pre_add() abort "{{{
  let g:vim_json_syntax_conceal = 0
endfunction "}}}
unlet s:plugin

call packages#add('rcmdnk/vim-markdown')

call packages#add('Shougo/neosnippet-snippets')

call packages#add('vim-jp/vimdoc-ja')

" TODO add 'build' attribute
call packages#add('nixprime/cpsm', { 'condition': !IsWindows() })

call packages#add('vim-scripts/smarty-syntax')

call packages#add('lambdalisue/vim-diffa')

call packages#add('othree/html5.vim')

call packages#add('cakebaker/scss-syntax.vim')

call packages#add('jwalton512/vim-blade')

call packages#add('dag/vim-fish')

let s:plugin = packages#add('Shougo/deoplete.nvim', {
      \   'condition': has('nvim'),
      \   'depends': [ 'context_filetype.vim' ],
      \   'post_add': '~/.vim/rc/plugins/deoplete.rc.vim'
      \ })
function! s:plugin.pre_add() abort "{{{
  let g:deoplete#enable_at_startup = 1
endfunction "}}}
unlet s:plugin

call packages#add('Shougo/neomru.vim')

" TODO add 'build' attribute
call packages#add('Shougo/vimproc.vim', {
      \   'condition': !IsWindows(),
      \ })

call packages#add('Shougo/context_filetype.vim')

let s:plugin = packages#add('Shougo/neocomplete.vim', {
      \   'condition': has('lua'),
      \   'depends': [ 'context_filetype.vim' ],
      \   'post_add': '~/.vim/rc/plugins/neocomplete.rc.vim'
      \ })
function! s:plugin.pre_add() abort "{{{
  let g:neocomplete#enable_at_startup = 1
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('Shougo/neosnippet.vim', {
      \   'depends': [ 'neosnippet-snippets', 'context_filetype.vim' ],
      \ })
function! s:plugin.pre_add() abort "{{{
  imap <silent> <C-k> <Plug>(neosnippet_jump_or_expand)
  smap <silent> <C-k> <Plug>(neosnippet_jump_or_expand)
  xmap <silent> <C-k> <Plug>(neosnippet_expand_target)
  imap <silent> <C-l> <Plug>(neosnippet_expand_or_jump)
  smap <silent> <C-l> <Plug>(neosnippet_expand_or_jump)
  xmap <silent> o <Plug>(neosnippet_register_oneshot_snippet)

  let g:neosnippet#enable_snipmate_compatibility = 1
  let g:neosnippet#enable_completed_snippet = 1
  let g:neosnippet#expand_word_boundary = 1
endfunction "}}}
function! s:plugin.post_add() abort "{{{
  if !exists('g:neosnippet#snippets_directory')
    let g:neosnippet#snippets_directory = ''
  endif

  let s:snippets_dir = '~/.vim/snippets'
  let s:dirs = split(g:neosnippet#snippets_directory, ',')
  let s:found = 0
  for s:dir in s:dirs
    if s:dir ==# s:snippets_dir
      let s:found = 1
    endif
  endfor

  if !s:found
    let g:neosnippet#snippets_directory = join(add(s:dirs, s:snippets_dir), ',')
  endif

  unlet s:dirs
  unlet s:snippets_dir
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('yyotti/neosnippet-additional', {
      \   'depends': [ 'neosnippet.vim' ],
      \ })
function! s:plugin.post_add() abort "{{{
  if !exists('g:neosnippet#snippets_directory')
    let g:neosnippet#snippets_directory = ''
  endif

  let s:snippets_dir =
        \ packages#get('neosnippet-additional').rtp . '/snippets/'
  let s:dirs = split(g:neosnippet#snippets_directory, ',')
  let s:found = 0
  for s:dir in s:dirs
    if s:dir ==# s:snippets_dir
      let s:found = 1
    endif

    unlet s:dir
  endfor

  if !s:found
    let g:neosnippet#snippets_directory =
          \ join(add(s:dirs, s:snippets_dir), ',')
  endif

  unlet s:dirs
  unlet s:snippets_dir
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('Shougo/unite.vim', {
      \   'depends': 'neomru.vim',
      \   'post_add': '~/.vim/rc/plugins/unite.rc.vim',
      \ })
function! s:plugin.pre_add() abort "{{{
  if !has('nvim') && v:version < 800
    nnoremap <silent> <Leader>ub :<C-u>Unite buffer file_mru<CR>
    nnoremap <silent> <Leader>uf
          \ :<C-u>Unite -buffer-name=files
          \   -no-split -multi-line -unique -silent
          \   `finddir('.git', ';') !=# '' ? 'file_rec/git' : ''`
          \   buffer_tab:- file file/new<CR>
    nnoremap <silent> <Leader>ul :<C-u>Unite line<CR>
    nnoremap <silent> <Leader>ug
          \ :<C-u>Unite grep -buffer-name=grep -no-start-insert -no-empty<CR>
    nnoremap <silent> <Leader>ur
          \ :<C-u>UniteResume -buffer-name=grep
          \   -no-start-insert -no-empty grep<CR>
    nnoremap <silent> <Leader>ue :<C-u>Unite menu:_<CR>

    nnoremap <silent> <Leader>n :<C-u>UniteNext<CR>
    nnoremap <silent> <Leader>p :<C-u>UnitePrevious<CR>
  endif
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('Shougo/denite.nvim', {
      \   'condition': has("nvim") || v:version >= 800,
      \   'post_add': '~/.vim/rc/plugins/denite.rc.vim',
      \ })
function! s:plugin.pre_add() abort "{{{
  nnoremap <silent> <Leader>ub :<C-u>Denite buffer file_old<CR>
  nnoremap <silent> <Leader>uf :<C-u>Denite file_rec<CR>
  nnoremap <silent> <Leader>ul :<C-u>Denite line<CR>
  nnoremap <silent> <Leader>ug
        \ :<C-u>Denite grep -mode=normal -no-empty -buffer-name=grep<CR>
  nnoremap <silent> <Leader>ur
        \ :<C-u>Denite -resume -mode=normal -no-empty -buffer-name=grep<CR>
  nnoremap <silent> <Leader>ue :<C-u>Denite menu:_<CR>

  nnoremap <silent> <Leader>n
        \ :<C-u>Denite -resume -select=+1 -immediately -buffer-name=grep<CR>
  nnoremap <silent> <Leader>p
        \ :<C-u>Denite -resume -select=-1 -immediately -buffer-name=grep<CR>
endfunction "}}}
unlet s:plugin

" TODO Use Vaffle or defx
let s:plugin = packages#add('Shougo/vimfiler.vim', {
      \   'depends': [ 'unite.vim' ],
      \ })
function! s:plugin.pre_add() abort "{{{
  nnoremap <silent> <Leader>fe :<C-u>VimFilerBufferDir -invisible<CR>

  let g:vimfiler_as_default_explorer = 1
  if IsWindows()
    let g:vimfiler_detect_drives = [
          \   'C:/', 'D:/', 'E:/', 'F:/', 'G:/',
          \   'H:/', 'I:/', 'J:/', 'K:/', 'L:/',
          \   'M:/', 'N:/',
          \ ]

    let g:unite_kind_file_use_trashbox = 1
  endif

  let g:vimfiler_force_overwrite_statusline = 0

  autocmd MyAutocmd FileType vimfiler call <SID>vimfiler_settings()
  function! s:vimfiler_settings() abort
    call vimfiler#set_execute_file('vim', [ 'nvim', 'vim', 'notepad' ])
    call vimfiler#set_execute_file('txt', [ 'nvim', 'vim', 'notepad' ])
  endfunction
endfunction "}}}
function! s:plugin.post_add() abort "{{{
  call vimfiler#custom#profile('default', 'context', {
        \   'save': 0,
        \   'parent': 0,
        \ })
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('Shougo/junkfile.vim', {
      \   'depends': [ 'unite.vim' ],
      \ })
function! s:plugin.pre_add() abort "{{{
  nnoremap <silent> <Leader>uj :<C-u>Unite junkfile/new junkfile<CR>
endfunction "}}}
unlet s:plugin

call packages#add('Shougo/neco-vim')

let s:plugin = packages#add('LeafCage/foldCC.vim')
function! s:plugin.pre_add() abort "{{{
  let g:foldCCtext_enable_autofdc_adjuster = 1
endfunction "}}}
function! s:plugin.post_add() abort "{{{
  set foldtext=FoldCCtext()
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('thinca/vim-ref', {
      \   'condition': executable('lynx'),
      \ })
function! s:plugin.pre_add() abort "{{{
  nmap K <Plug>(ref-keyword)

  if IsWindows()
    let g:ref_refe_encoding = 'cp932'
  endif

  let g:ref_lynx_use_cache = 1
  let g:ref_lynx_start_linenumber = 0
  let g:ref_lynx_hide_url_number = 0

  " PHP
  let g:ref_phpmanual_path = $HOME . '/.vim/refs/php-chunked-xhtml'

  autocmd MyAutocmd FileType ref nnoremap <silent> <buffer> q :q<CR>
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('tyru/eskk.vim')
function! s:plugin.pre_add() abort "{{{
  imap <C-j> <Plug>(eskk:toggle)
  cmap <C-j> <Plug>(eskk:toggle)

  let g:eskk#directory = expand('~/.skk')
  let g:eskk#debug = 0
  let g:eskk#show_annotation = 1

  " User dic
  let g:eskk#dictionary = {
        \   'path': g:eskk#directory . '/skk-jisyo.user',
        \   'sorted': 0,
        \   'encoding': 'utf-8',
        \ }

  let g:eskk#large_dictionary = {
        \   'path': g:eskk#directory . '/SKK-JISYO.L',
        \   'sorted': 1,
        \   'encoding': 'euc-jp',
        \ }
  " google-ime-skk
  if executable('google-ime-skk')
    let g:eskk#server = {
          \   'host': 'localhost',
          \   'port': 55100,
          \   'type': 'dictionary',
          \ }
  endif

  autocmd MyAutocmd User eskk-initialize-pre call s:eskk_initial_pre()
  function! s:eskk_initial_pre() abort "{{{
    let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
    call t.add_map('z ', "\u3000")
    call t.add_map('z(', "\uff08")
    call t.add_map('z)', "\uff09")
    call t.add_map('~', "\u301c")
    call eskk#register_mode_table('hira', t)
    unlet t
  endfunction "}}}
endfunction "}}}
unlet s:plugin

call packages#add('tyru/open-browser.vim')

let s:plugin = packages#add('kana/vim-operator-replace', {
      \   'depends': [ 'vim-operator-user' ],
      \ })
function! s:plugin.pre_add() abort "{{{
  map R <Plug>(operator-replace)
  xmap p <Plug>(operator-replace)
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('rhysd/vim-operator-surround', {
      \   'depends': [ 'vim-operator-user' ],
      \ })
function! s:plugin.pre_add() abort "{{{
  map <silent> ra <Plug>(operator-surround-append)
  map <silent> rd <Plug>(operator-surround-delete)
  map <silent> rc <Plug>(operator-surround-replace)
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('airblade/vim-gitgutter')
function! s:plugin.pre_add() abort "{{{
  let g:gitgutter_sign_added = 'A'
  let g:gitgutter_sign_modified = 'M'
  let g:gitgutter_sign_removed = 'D'
  let g:gitgutter_sign_modified_removed = 'MD'

  let g:gitgutter_map_keys = 0
  let g:gitgutter_async = 0

  nmap [c <Plug>GitGutterPrevHunkzvzz
  nmap ]c <Plug>GitGutterNextHunkzvzz
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('easymotion/vim-easymotion', {
      \   'depends': [ 'vim-repeat' ],
      \ })
function! s:plugin.pre_add() abort "{{{
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
endfunction "}}}
unlet s:plugin

call packages#add('vim-scripts/sudo.vim', {
      \   'condition': !IsWindows(),
      \ })

let s:plugin = packages#add('cohama/agit.vim')
function! s:plugin.pre_add() abort "{{{
  nnoremap <silent> <Leader>ga :<C-u>Agit<CR>
  nnoremap <silent> <Leader>gf :<C-u>AgitFile<CR>
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('simeji/winresizer')
function! s:plugin.pre_add() abort "{{{
  if has('gui_running')
    let g:winresizer_gui_enable = 1
    nnoremap <C-w>R :<C-u>WinResizerStartResizeGUI<CR>
  endif

  let g:winresizer_vert_resize = 5
  nnoremap <C-w>r :<C-u>WinResizerStartResize<CR>
endfunction "}}}
function! s:plugin.post_add() abort "{{{
  if exists('g:winresizer_start_key')
    execute 'unmap' g:winresizer_start_key
    if has('gui_running')
      execute 'unmap' g:winresizer_gui_start_key
    endif
  endif
endfunction "}}}
unlet s:plugin

" TODO >=7.4.503
let s:plugin = packages#add('neomake/neomake', {
      \   'condition': has('nvim') || v:version >= 800,
      \ })
function! s:plugin.pre_add() abort "{{{
  autocmd MyAutocmd BufWritePost *
        \   if filereadable(expand('<afile>'))
        \ |   Neomake
        \ |   call lightline#update()
        \ | endif

  let g:neomake_remove_invalid_entries = 1

  let g:neomake_scss_scsslint_maker = {
        \   'exe': 'scss-lint',
        \   'errorformat': '%A%f:%l [%t] %m',
        \ }

  " Vimscript
  if !IsWindows()
    if !executable('vimlparser')
      let g:neomake_vim_enabled_makers = [ 'vimlint' ]
      let g:neomake_vim_vimlint_maker = {
            \   'exe': expand('~/.vim/script/vimlint.sh'),
            \   'args': [ '-u' ],
            \   'errorformat': '%f:%l:%c:%trror: %m,%f:%l:%c:%tarning: %m,%f:%l:%c:%m',
            \ }
    else
      let g:neomake_vim_enabled_makers = [ 'vimlparser' ]
      let g:neomake_vim_vimlparser_maker = {
            \   'exe': 'vimlparser',
            \   'errorformat': '%f:%l:%c: vimlparser: %m',
            \ }
      if has('nvim')
        let g:neomake_vim_vimlparser_maker['args'] = [ '-neovim' ]
      endif
    endif
  endif

  if executable('golint')
    let g:neomake_go_enabled_makers = [ 'go', 'golint' ]
    let g:neomake_go_golint_maker = {
          \   'errorformat': '%E%f:%l:%c: %m,%-G%.%#'
          \ }
  endif
endfunction "}}}
function! s:plugin.post_add() abort "{{{
  highlight link NeomakeErrorSign ErrorMsg
endfunction "}}}
unlet s:plugin

" TODO <7.4.503
call packages#add('osyo-manga/shabadou.vim', {
      \   'condition': !has('nvim') && v:version < 800,
      \ })

" TODO <7.4.503
let s:plugin = packages#add('osyo-manga/vim-watchdogs', {
      \   'condition': !has('nvim') && v:version < 800,
      \   'depends': [ 'vim-quickrun', 'vimproc.vim', 'shabadou.vim' ],
      \ })
function! s:plugin.pre_add() abort "{{{
  let g:watchdogs_check_BufWritePost_enable = 1
  let g:watchdogs_check_BufWritePost_enable_on_wq = 0

  if !exists('g:quickrun_config')
    let g:quickrun_config = {}
  endif
  if !has_key(g:quickrun_config, 'watchdogs_checker/_')
    let g:quickrun_config['watchdogs_checker/_'] = {}
  endif
  let g:quickrun_config['watchdogs_checker/_']['hook/close_quickfix/enable_exit'] = 1
endfunction "}}}
function! s:plugin.post_add() abort "{{{
  call watchdogs#setup(g:quickrun_config)
endfunction "}}}
unlet s:plugin

" TODO <7.4.503
let s:plugin = packages#add('KazuakiM/vim-qfstatusline', {
      \   'condition': !has('nvim') && v:version < 800,
      \ })
function! s:plugin.pre_add() abort "{{{
  if !exists('g:quickrun_config')
    let g:quickrun_config = {}
  endif
  if !has_key(g:quickrun_config, 'watchdogs_checker/_')
    let g:quickrun_config['watchdogs_checker/_'] = {}
  endif
  let g:quickrun_config['watchdogs_checker/_']['hook/back_window/enable_exit'] = 0
  let g:quickrun_config['watchdogs_checker/_']['hook/back_window/priority_exit'] = 1
  let g:quickrun_config['watchdogs_checker/_']['hook/qfstatusline_update/enable_exit'] = 1
  let g:quickrun_config['watchdogs_checker/_']['hook/qfstatusline_update/priority_exit'] = 2

  let g:Qfstatusline#Text = 0
endfunction "}}}
function! s:plugin.post_add() abort "{{{
  let g:Qfstatusline#UpdateCmd = exists('*lightline#update') ?
        \ function('lightline#update') : function('qfstatusline#Update')
endfunction "}}}
unlet s:plugin

" TODO <7.4.503
let s:plugin = packages#add('KazuakiM/vim-qfsigns', {
      \   'condition': !has('nvim') && v:version < 800,
      \ })
function! s:plugin.pre_add() abort "{{{
  if !exists('g:quickrun_config')
    let g:quickrun_config = {}
  endif
  if !has_key(g:quickrun_config, 'watchdogs_checker/_')
    let g:quickrun_config['watchdogs_checker/_'] = {}
  endif
  let g:quickrun_config['watchdogs_checker/_']['hook/back_window/enable_exit'] = 0
  let g:quickrun_config['watchdogs_checker/_']['hook/back_window/priority_exit'] = 1
  let g:quickrun_config['watchdogs_checker/_']['hook/qfstatusline_update/enable_exit'] = 1
  let g:quickrun_config['watchdogs_checker/_']['hook/qfstatusline_update/priority_exit'] = 2

  let g:Qfstatusline#Text = 0
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('thinca/vim-quickrun')
function! s:plugin.pre_add() abort "{{{
  nmap <silent> <Leader>r <Plug>(quickrun)
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('haya14busa/vim-operator-flashy', {
      \   'depends': [ 'vim-operator-user' ],
      \ })
function! s:plugin.pre_add() abort "{{{
  let g:operator#flashy#flash_time = 300
endfunction "}}}
function! s:plugin.post_add() abort "{{{
  map y <Plug>(operator-flashy)
  nmap Y <Plug>(operator-flashy)$

  highlight Flashy ctermbg=8 guibg=#666666
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('yyotti/vim-autoupload')
function! s:plugin.pre_add() abort "{{{
  autocmd MyAutocmd BufWinEnter *.php,*.tpl,*.css,*.js
        \ call autoupload#init(0)
  autocmd MyAutocmd BufWritePost *.php,*.tpl,*.css,*.js
        \ call autoupload#upload(0)
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('benjifisher/matchit.zip')
function! s:plugin.pre_add() abort "{{{
  if exists('g:loaded_matchit')
    unlet g:loaded_matchit
  endif
endfunction "}}}
unlet s:plugin

call packages#add('syngan/vim-vimlint', {
      \   'condition': !executable('vimlparser'),
      \   'depends': [ 'vim-vimlparser' ],
      \ })

call packages#add('ynkdir/vim-vimlparser', {
      \   'condition': !executable('vimlparser'),
      \ })

let s:plugin = packages#add('osyo-manga/vim-precious', {
      \   'depends': [ 'context_filetype.vim' ],
      \ })
function! s:plugin.pre_add() abort "{{{
  let g:precious_enable_switch_CursorMoved = { '*': 0 }
  autocmd MyAutocmd InsertEnter * PreciousSwitch
  autocmd MyAutocmd InsertLeave * PreciousReset
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('adoy/vim-php-refactoring-toolbox')
function! s:plugin.pre_add() abort "{{{
  let g:vim_php_refactoring_use_default_mapping = 0

  " TODO map only *.php
  nnoremap <silent> rflv :call PhpRenameLocalVariable()<CR>
  nnoremap <silent> rfcv :call PhpRenameClassVariable()<CR>
  nnoremap <silent> rfrm :call PhpRenameMethod()<CR>
  nnoremap <silent> rfdu :call PhpDetectUnusedUseStatements()<CR>
  nnoremap <silent> rfec :call PhpExtractClassProperty()<CR>
  nnoremap <silent> rfeu :call PhpExtractUse()<CR>

  vnoremap <silent> rfem :call PhpExtractMethod()<CR>
  vnoremap <silent> <Leader>== :call PhpAlignAssigns()<CR>
endfunction "}}}
unlet s:plugin

call packages#add('AndrewRadev/linediff.vim')

let s:plugin = packages#add('ciaranm/securemodelines')
function! s:plugin.pre_add() abort "{{{
  set modelines=0
  set nomodeline
endfunction "}}}
unlet s:plugin

" TODO Execute :GoInstallBinaries after install('build' option)
"           or :GoUpdateBinaries after update('build' option)
let s:plugin = packages#add('fatih/vim-go', { 'condition': executable('go') })
function! s:plugin.pre_add() abort "{{{
  let g:go_fmt_fail_silently = 1
endfunction "}}}
function! s:plugin.post_add() abort "{{{
  execute 'set runtimepath+='
        \ . globpath($GOPATH, 'src/github.com/nsf/gocode/vim')
endfunction "}}}
unlet s:plugin

call packages#end()
