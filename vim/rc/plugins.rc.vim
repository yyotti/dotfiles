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

" Disable PHP formatoptions
let g:PHP_autoformatcomment = 0

" Update filetype
autocmd MyAutocmd BufWritePost * nested
      \ if &l:filetype ==# '' || exists('b:ftdetect') |
      \   unlet! b:ftdetect |
      \   filetype detect |
      \ endif
"}}}

" Python3 version "{{{
if exists(':python3') ==# 2
  let s:python3_version =
        \ matchstr(
        \   execute(
        \     'python3 import platform; print(platform.python_version())',
        \     'silent!'
        \   ),
        \   '\d\+\.\d\+\.\d\+'
        \ )
  let s:has_python35 =
        \ !empty(s:python3_version) && s:python3_version >=# '3.5.0'

  unlet s:python3_version
else
  let s:has_python35 = 0
endif
"}}}

if !packages#begin()
  finish
endif

autocmd plugin-packages User post-plugins-loaded nested
      \ source ~/.vim/rc/colorscheme.rc.vim

let s:plugin = packages#add('tyru/caw.vim', {
      \   'depends': [
      \     'kana/vim-operator-user',
      \     'tpope/vim-repeat' ],
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

call packages#add('nixprime/cpsm', {
      \   'condition': !IsWindows(),
      \   'build': 'env PY3=ON ./install.sh',
      \ })

call packages#add('vim-scripts/smarty-syntax')

call packages#add('lambdalisue/vim-diffa')

call packages#add('othree/html5.vim')

call packages#add('cakebaker/scss-syntax.vim')

call packages#add('jwalton512/vim-blade')

call packages#add('dag/vim-fish')

let s:plugin = packages#add('Shougo/deoplete.nvim', {
      \   'condition': has('nvim') && has('python3'),
      \   'depends': [ 'Shougo/context_filetype.vim' ],
      \   'post_add': '~/.vim/rc/plugins/deoplete.rc.vim'
      \ })
function! s:plugin.pre_add() abort "{{{
  let g:deoplete#enable_at_startup = 1
endfunction "}}}
unlet s:plugin

" let s:plugin = packages#add('zchee/deoplete-go', {
"       \   'condition': executable('go'),
"       \   'depends': [ 'Shougo/deoplete.nvim' ],
"       \   'build': '',
"       \ })
" function! s:plugin.pre_add() abort "{{{
"   let g:deoplete#sources#go#gocode_binary =
"         \ utils#join_path($GOPATH, 'bin' , 'gocode')
"   let g:deoplete#sources#go#sort_class = [
"         \   'package',
"         \   'func',
"         \   'type',
"         \   'var',
"         \   'const',
"         \ ]
"   let g:deoplete#sources#go#use_cache = 1
"   let g:deoplete#sources#go#json_directory =
"         \ utils#join_path($HOME, '.cache', 'deoplete', 'go', 'cache')
"   if !isdirectory(g:deoplete#sources#go#json_directory)
"     call mkdir(g:deoplete#sources#go#json_directory, 'p')
"   endif
" endfunction "}}}
" unlet s:plugin

call packages#add('Shougo/neomru.vim')

call packages#add('Shougo/vimproc.vim', {
      \   'condition': !IsWindows(),
      \   'build': 'make',
      \ })

call packages#add('Shougo/context_filetype.vim')

let s:plugin = packages#add('Shougo/neocomplete.vim', {
      \   'condition': has('lua') && !has('nvim'),
      \   'depends': [ 'Shougo/context_filetype.vim' ],
      \   'post_add': '~/.vim/rc/plugins/neocomplete.rc.vim'
      \ })
function! s:plugin.pre_add() abort "{{{
  let g:neocomplete#enable_at_startup = 1
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('Shougo/neosnippet.vim', {
      \   'depends': [
      \     'Shougo/neosnippet-snippets',
      \     'Shougo/context_filetype.vim'
      \   ],
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
  let g:neosnippet#snippets_directory = '~/.vim/snippets'
endfunction "}}}
unlet s:plugin

call packages#add('yyotti/neosnippet-php', {
      \   'depends': [ 'Shougo/neosnippet.vim' ],
      \   'build': 'php install.php -d"$HOME/.vim/refs/php-chunked-xhtml"',
      \ })

let s:plugin = packages#add('Shougo/unite.vim', {
      \   'depends': 'Shougo/neomru.vim',
      \   'post_add': '~/.vim/rc/plugins/unite.rc.vim',
      \ })
function! s:plugin.pre_add() abort "{{{
  if empty(packages#get('Shougo/denite.nvim'))
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
      \   'condition': has('nvim') || v:version >= 800 && has('python3'),
      \   'post_add': '~/.vim/rc/plugins/denite.rc.vim',
      \   'build': 'sh ~/.vim/script/denite.nvim.patch.sh'
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
  nnoremap <silent> <Leader>uc :<C-u>Denite command_history command<CR>

  nnoremap <silent> <Leader>n
        \ :<C-u>Denite -resume -select=+1 -immediately -buffer-name=grep<CR>
  nnoremap <silent> <Leader>p
        \ :<C-u>Denite -resume -select=-1 -immediately -buffer-name=grep<CR>
endfunction "}}}
unlet s:plugin

" TODO Use Vaffle or defx
let s:plugin = packages#add('Shougo/vimfiler.vim', {
      \   'depends': [ 'Shougo/unite.vim' ],
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
      \   'depends': [ 'Shougo/unite.vim' ],
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

let s:plugin = packages#add('tyru/eskk.vim', {
      \   'build': 'sh ~/.vim/script/eskk.vim-patch.sh'
      \ })
function! s:plugin.pre_add() abort "{{{
  imap <C-j> <Plug>(eskk:toggle)
  cmap <C-j> <Plug>(eskk:toggle)

  if !exists('g:eskk#directory')
    let g:eskk#directory = expand('~/.eskk')
  endif
  let g:eskk#show_annotation = 1

  " User dic
  let g:eskk#dictionary = g:eskk#directory . '/skk-jisyo'

  let large_dic = ''
  if filereadable('/usr/share/skk/SKK-JISYO.L')
    let large_dic = '/usr/share/skk/SKK-JISYO.L'
  elseif filereadable('/usr/local/share/skk/SKK-JISYO.L')
    let lerge_dic = '/usr/share/skk/SKK-JISYO.L'
  endif

  if !empty(large_dic)
    let g:eskk#large_dictionary = {
          \   'path': large_dic,
          \   'sorted': 1,
          \   'encoding': 'euc-jp',
          \ }

  endif

  " google-ime-skk
  if executable('google-ime-skk')
    let g:eskk#server = {
          \   'host': 'localhost',
          \   'port': 55100,
          \   'timeout': 200,
          \ }
  else
    let g:eskk#server = {
          \   'host': 'localhost',
          \   'timeout': 200,
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
      \   'depends': [ 'kana/vim-operator-user' ],
      \ })
function! s:plugin.pre_add() abort "{{{
  map R <Plug>(operator-replace)
  xmap p <Plug>(operator-replace)
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('rhysd/vim-operator-surround', {
      \   'depends': [ 'kana/vim-operator-user' ],
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
      \   'depends': [ 'tpope/vim-repeat' ],
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

let s:plugin = packages#add('neomake/neomake', {
      \   'condition': has('nvim') || v:version >= 800 || has('patch-7.4.503'),
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
            \   'errorformat':
            \     '%f:%l:%c:%trror: %m,%f:%l:%c:%tarning: %m,%f:%l:%c:%m',
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

call packages#add('osyo-manga/shabadou.vim', {
      \   'condition': empty(packages#get('neomake/neomake')),
      \ })

let s:plugin = packages#add('osyo-manga/vim-watchdogs', {
      \   'depends': [
      \     'thinca/vim-quickrun',
      \     'Shougo/vimproc.vim',
      \     'osyo-manga/shabadou.vim'
      \   ],
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
  let config = {
        \   'hook/close_quickfix/enable_exit': 1,
        \ }
  let g:quickrun_config['watchdogs_checker/_'] =
        \ extend(g:quickrun_config['watchdogs_checker/_'], config, 'force')
endfunction "}}}
function! s:plugin.post_add() abort "{{{
  call watchdogs#setup(g:quickrun_config)
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('KazuakiM/vim-qfstatusline', {
      \   'depends': [ 'osyo-manga/vim-watchdogs' ],
      \ })
function! s:plugin.pre_add() abort "{{{
  if !exists('g:quickrun_config')
    let g:quickrun_config = {}
  endif
  if !has_key(g:quickrun_config, 'watchdogs_checker/_')
    let g:quickrun_config['watchdogs_checker/_'] = {}
  endif
  let config = {
        \   'hook/back_window/enable_exit': 0,
        \   'hook/back_window/priority_exit': 1,
        \   'hook/qfstatusline_update/enable_exit': 1,
        \   'hook/qfstatusline_update/priority_exit': 2,
        \ }
  let g:quickrun_config['watchdogs_checker/_'] =
        \ extend(g:quickrun_config['watchdogs_checker/_'], config, 'force')

  let g:Qfstatusline#Text = 0
endfunction "}}}
function! s:plugin.post_add() abort "{{{
  let g:Qfstatusline#UpdateCmd = exists('*lightline#update') ?
        \ function('lightline#update') : function('qfstatusline#Update')
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('KazuakiM/vim-qfsigns', {
      \   'depends': [ 'osyo-manga/vim-watchdogs' ],
      \ })
function! s:plugin.pre_add() abort "{{{
  if !exists('g:quickrun_config')
    let g:quickrun_config = {}
  endif
  if !has_key(g:quickrun_config, 'watchdogs_checker/_')
    let g:quickrun_config['watchdogs_checker/_'] = {}
  endif
  let config = {
        \   'hook/back_window/enable_exit': 0,
        \   'hook/back_window/priority_exit': 1,
        \   'hook/qfstatusline_update/enable_exit': 1,
        \   'hook/qfstatusline_update/priority_exit': 2,
        \ }
  let g:quickrun_config['watchdogs_checker/_'] =
        \ extend(g:quickrun_config['watchdogs_checker/_'], config, 'force')

  let g:Qfstatusline#Text = 0
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('thinca/vim-quickrun')
function! s:plugin.pre_add() abort "{{{
  nmap <silent> <Leader>r <Plug>(quickrun)
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('haya14busa/vim-operator-flashy', {
      \   'depends': [ 'kana/vim-operator-user' ],
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
      \   'depends': [ 'ynkdir/vim-vimlparser' ],
      \ })

call packages#add('ynkdir/vim-vimlparser', {
      \   'condition': !executable('vimlparser'),
      \ })

let s:plugin = packages#add('osyo-manga/vim-precious', {
      \   'depends': [ 'Shougo/context_filetype.vim' ],
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

  function! InitPhpRefactoringToolbox() abort "{{{
    nnoremap <buffer> <silent> rflv :call PhpRenameLocalVariable()<CR>
    nnoremap <buffer> <silent> rfcv :call PhpRenameClassVariable()<CR>
    nnoremap <buffer> <silent> rfrm :call PhpRenameMethod()<CR>
    nnoremap <buffer> <silent> rfdu :call PhpDetectUnusedUseStatements()<CR>
    nnoremap <buffer> <silent> rfec :call PhpExtractClassProperty()<CR>
    nnoremap <buffer> <silent> rfeu :call PhpExtractUse()<CR>

    vnoremap <buffer> <silent> rfem :call PhpExtractMethod()<CR>
    vnoremap <buffer> <silent> <Leader>== :call PhpAlignAssigns()<CR>
  endfunction "}}}
  autocmd MyAutocmd FileType php call InitPhpRefactoringToolbox()
endfunction "}}}
unlet s:plugin

call packages#add('AndrewRadev/linediff.vim')

let s:plugin = packages#add('ciaranm/securemodelines')
function! s:plugin.pre_add() abort "{{{
  set modelines=0
  set nomodeline
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('fatih/vim-go', { 'condition': executable('go') })
function! s:plugin.pre_add() abort "{{{
  let g:go_fmt_fail_silently = 1
endfunction "}}}
function! s:plugin.post_add() abort "{{{
  if !executable('gocode')
    GoInstallBinaries
  endif

  execute 'set runtimepath+='
        \ . globpath($GOPATH, 'src/github.com/nsf/gocode/vim')
endfunction "}}}
unlet s:plugin

call packages#add('chemzqm/vim-easygit')

let s:plugin = packages#add('chemzqm/denite-git', {
      \   'condition': s:has_python35,
      \   'depends': [ 'Shougo/denite.nvim', 'chemzqm/vim-easygit' ],
      \   'build': 'sh ~/.vim/script/denite-git-patch.sh',
      \ })
function! s:plugin.pre_add() abort "{{{
  nnoremap <silent> <Leader>Gs :<C-u>Denite gitstatus<CR>
endfunction "}}}
unlet s:plugin

let s:plugin = packages#add('davidhalter/jedi-vim', {
      \   'condition': (has('python') || has('python3'))
      \                   && executable('python') && !has('nvim'),
      \   'build': 'git submodule update --init',
      \ })
function! s:plugin.pre_add() abort "{{{
  let g:jedi#auto_initialization = 0
  let g:jedi#popup_select_first = 0
  let g:jedi#popup_on_dot = 0
  let g:jedi#auto_vim_configuration = 0
  let g:jedi#show_call_signatures = 0
  let g:jedi#completions_enabled = 0
  let g:jedi#smart_auto_mappings = 0
endfunction "}}}
unlet s:plugin

call packages#end()
