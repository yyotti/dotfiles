"---------------------------------------------------------------------------
" vim-plug:
"

let s:path = fnamemodify(expand('$_CACHE/vim-plug'), ':p')

let g:plug_threads = 5
let g:plug_timeout = 10

let s:gitgutter_sign_added = "\uf067"
let s:gitgutter_sign_modified = "\uf069"
let s:gitgutter_sign_removed = "\uf068"

call plug#begin(s:path)

" ================ Not lazy ============================
Plug 'Shougo/vimproc.vim', {
      \   'do': 'make',
      \ }

Plug 'w0ng/vim-hybrid'

Plug 'hail2u/vim-css3-syntax'

Plug 'othree/html5.vim'

Plug 'cespare/vim-toml'

Plug 'kana/vim-textobj-user'

Plug 'Vimjas/vim-python-pep8-indent'

Plug 'kana/vim-operator-user'

Plug 'Shougo/context_filetype.vim'

Plug 'vim-jp/vimdoc-ja'

Plug 'tpope/vim-repeat'

Plug 'cakebaker/scss-syntax.vim'

Plug 'rcmdnk/vim-markdown'

Plug 'Shougo/neosnippet-snippets'

Plug 'Shougo/neosnippet.vim', {
      \   'depends': [ 'neosnippet-snippets', 'context_filetype.vim' ],
      \ }
function! s:neosnippet_init() abort "{{{
  let g:neosnippet#enable_snipmate_compatibility = 1
  let g:neosnippet#enable_completed_snippet = 1
  let g:neosnippet#expand_word_boundary = 1

  let g:neosnippet#snippets_directory =
        \ fnamemodify(expand('$_VIMDIR/snippets'), ':p')

  imap <silent> <C-k> <Plug>(neosnippet_jump_or_expand)
  smap <silent> <C-k> <Plug>(neosnippet_jump_or_expand)
  xmap <silent> <C-k> <Plug>(neosnippet_expand_target)
  imap <silent> <C-l> <Plug>(neosnippet_expand_or_jump)
  smap <silent> <C-l> <Plug>(neosnippet_expand_or_jump)
  xmap <silent> o <Plug>(neosnippet_register_oneshot_snippet)
endfunction "}}}
call s:neosnippet_init()

Plug 'PProvost/vim-ps1'

Plug 'blueyed/smarty.vim'

Plug 'elzr/vim-json', {
      \   'for': [ 'json' ],
      \ }
function! s:vim_json_init() abort "{{{
  let g:vim_json_syntax_conceal = 0
endfunction "}}}
call s:vim_json_init()

Plug 'HerringtonDarkholme/yats.vim'

Plug 'othree/yajs.vim'

Plug 'pangloss/vim-javascript'

Plug 'MaxMEllon/vim-jsx-pretty', {
      \   'depends': 'yajs.vim',
      \ }
function! s:vim_jsx_pretty_init() abort "{{{
  let g:vim_jsx_pretty_colorful_config = 1
endfunction "}}}
call s:vim_jsx_pretty_init()

Plug 'autozimu/LanguageClient-neovim', {
      \   'branch': 'next',
      \   'do': 'bash install.sh',
      \ }
function! s:language_client_neovim_init() abort "{{{
  let g:LanguageClient_serverCommands = get(g:, 'LanguageClient_serverCommands', {})
  let g:LanguageClient_rootMarkers = get(g:, 'LanguageClient_rootMarkers', {})

  if executable('pyls')
    let g:LanguageClient_serverCommands.python = [ 'pyls' ]
  endif

  if executable('bingo')
    let g:LanguageClient_serverCommands.go = [ 'bingo', '-mode', 'stdio' ]
  elseif executable('gopls')
    let g:LanguageClient_serverCommands.go = [ 'gopls' ]
  endif

  if executable('node') &&
       \ filereadable(expand('$XDG_DATA_HOME/yarn/global/node_modules/intelephense/lib/intelephense.js'))
    let s:php_language_server = expand('$XDG_DATA_HOME/yarn/global/node_modules/intelephense/lib/intelephense.js')
    let g:LanguageClient_serverCommands.php = [ 'node', s:php_language_server, '--stdio' ]
  endif

  if executable('rls')
    " let g:LanguageClient_serverCommands.rust = [ 'rustup', 'run', 'stable', 'rls' ]
    let g:LanguageClient_serverCommands.rust = [ 'rustup', 'run', 'beta', 'rls' ]
  endif

  " if executable('javascript-typescript-stdio')
  "   let g:LanguageClient_serverCommands.javascript = [ 'javascript-typescript-stdio' ]
  "   let g:LanguageClient_serverCommands.typescript = [ 'javascript-typescript-stdio' ]
  "
  "   let g:LanguageClient_rootMarkers.javascript = [ '.git', 'package.json' ]
  "   let g:LanguageClient_rootMarkers.typescript = [ '.git', 'package.json' ]
  " endif

  autocmd MyAutocmd FileType * call <SID>lc_map()
  function! s:lc_map() abort "{{{
    if has_key(g:LanguageClient_serverCommands, &filetype)
      nnoremap <buffer> <silent> gd
            \ :<C-u>call LanguageClient#textDocument_definition()<CR>
      nnoremap <buffer> <silent> gD
            \ :<C-u>call LanguageClient#textDocument_typeDefinition()<CR>
      nnoremap <buffer> <silent> gi
            \ :<C-u>call LanguageClient#textDocument_implementation()<CR>
      nnoremap <buffer> <silent> gr
            \ :<C-u>call LanguageClient#textDocument_references()<CR>
      nnoremap <buffer> <silent> <LocalLeader>r
            \ :<C-u>call LanguageClient#textDocument_rename()<CR>
      nnoremap <buffer> <silent> <LocalLeader>f
            \ :<C-u>call LanguageClient#textDocument_formatting_sync()<CR>
      nnoremap <buffer> <silent> <LocalLeader>h
            \ :<C-u>call LanguageClient#textDocument_hover()<CR>
      nnoremap <buffer> <silent> <LocalLeader>H
            \ :<C-u>call LanguageClient#textDocument_documentHighlight()<CR>
      nnoremap <buffer> <silent> <LocalLeader>c
            \ :<C-u>call LanguageClient_contextMenu()<CR>
    endif
  endfunction "}}}
endfunction "}}}
call s:language_client_neovim_init()

Plug 'roxma/nvim-yarp'

Plug 'ncm2/ncm2', {
      \   'depends': 'nvim-yarp',
      \ }
function! s:ncm2_init() abort "{{{
  let g:ncm2#auto_popup = 1
  autocmd MyAutocmd BufEnter *
        \ if exists('g:ncm2_is_installed') || isdirectory(g:plugs['ncm2'].dir)
        \|  call ncm2#enable_for_buffer()
        \|  let g:ncm2_is_installed = v:true
        \|endif

  inoremap <expr> <nowait> <CR> (pumvisible() ? "\<C-y>\<CR>" : "\<CR>")

  " Disable when eskk enabled
  autocmd MyAutocmd User eskk-enable-post call ncm2#disable_for_buffer()
  autocmd MyAutocmd User eskk-disable-post call ncm2#enable_for_buffer()
endfunction "}}}
call s:ncm2_init()

Plug 'ncm2/ncm2-bufword', {
      \   'depends': 'ncm2',
      \ }

Plug 'ncm2/ncm2-path', {
      \   'depends': 'ncm2',
      \ }

Plug 'ncm2/ncm2-neosnippet', {
      \   'depends': [ 'ncm2', 'neosnippet.vim' ],
      \ }

Plug 'ncm2/ncm2-vim', {
      \   'depends': [ 'ncm2', 'neco-vim' ],
      \ }

" Plug 'itchyny/vim-parenmatch'

Plug 'LeafCage/foldCC.vim'

" load order: themes -> airline
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline', {
      \   'depends': 'vim-airline-themes',
      \ }
function! s:vim_airline_init() abort "{{{
  let g:airline_skip_empty_sections = 1
  let g:airline#extensions#languageclient#enabled = 0

  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif

  let g:airline_symbols.maxlinenr = ''
  let g:airline_left_sep = "\ue0b0"
  let g:airline_left_alt_sep = "\ue0b1"
  let g:airline_right_sep = "\ue0b2"
  let g:airline_right_alt_sep = "\ue0b3"

  let g:airline_symbols.linenr = "\ue0a1"
  let g:airline_symbols.readonly = "\uf023"
  let g:airline_symbols.branch = "\uf126"

  let g:airline#extensions#ale#error_symbol = "\uf057"
  let g:airline#extensions#ale#warning_symbol = "\uf071"

  let g:airline#extensions#hunks#enabled = 1

  " vim-gitgutter
  let g:airline#extensions#hunks#non_zero_only = 1
  let g:airline#extensions#hunks#hunk_symbols = [
        \   get(g:, 'gitgutter_sign_added', s:gitgutter_sign_added),
        \   get(g:, 'gitgutter_sign_modified', s:gitgutter_sign_modified),
        \   get(g:, 'gitgutter_sign_removed', s:gitgutter_sign_removed),
        \ ]

endfunction "}}}
call s:vim_airline_init()
autocmd MyAutocmd User AirlineAfterInit call <SID>airline_init()
function! s:airline_init() abort "{{{
  " eskk.vim
  function! EskkMode() abort "{{{
    return exists('*eskk#statusline') && !empty(eskk#statusline()) ?
          \ matchlist(eskk#statusline(), '^\[eskk:\(.\+\)\]$')[1] : ''
  endfunction "}}}
  call airline#parts#define_function('eskk', 'EskkMode')

  call airline#parts#define('lineinfo', {
        \   'raw': ' %3v %{g:airline_symbols.linenr}%3l/%L',
        \ })
  let l:section_b = []
  call add(l:section_b, 'hunks')

  if has_key(g:plugs, 'gina.vim') && isdirectory(g:plugs['gina.vim'].dir)
    call plug#load('gina.vim')
    call add(l:section_b, '%{gina#component#repo#branch()!=#""?g:airline_symbols.branch:""}%{gina#component#repo#branch()}')
  endif

  let g:airline_section_a = airline#section#create_left([ 'mode', 'eskk' ])
  let g:airline_section_b = airline#section#create(l:section_b)
  let g:airline_section_z = airline#section#create([ 'windowswap', 'obsession', 'lineinfo' ])
endfunction "}}}

Plug 'w0rp/ale'
function! s:ale_init() abort "{{{
  " let g:ale_lint_on_enter = 0
  let g:ale_sign_error = "\u2a09"
  let g:ale_sign_warning = "\u26a0"
  let g:ale_lint_on_text_changed = 'never'
  let g:ale_lint_on_insert_leave = 0

  nmap <silent> [e <Plug>(ale_previous)
  nmap <silent> [E <Plug>(ale_first)
  nmap <silent> ]e <Plug>(ale_next)
  nmap <silent> ]E <Plug>(ale_last)

  if !exists('g:ale_linters')
    let g:ale_linters = {}
  endif
  if !exists('g:ale_fixers')
    let g:ale_fixers = {}
  endif
  let g:ale_fixers['*'] = [ 'remove_trailing_lines' ]
  let g:ale_fix_on_save = 1

  if executable('golangci-lint')
    let g:ale_linters.go = [ 'golangci-lint' ]
    let g:ale_go_golangci_lint_package = v:true
    let g:ale_go_golangci_lint_options = join([
          \   '--tests',
          \   '--enable-all',
          \ ])
    "\   '--fast',
  elseif executable('gometalinter')
    " NOTE: gometalinter is old
    let g:ale_linters.go = [ 'gometalinter' ]
    let g:ale_go_gometalinter_options = join([
          \   '--tests',
          \   '--fast',
          \   '--enable=errcheck',
          \   '--enable=deadcode',
          \   '--enable=unparam',
          \ ])
    "\   '--enable=interfacer',
    "\   '--enable=misspell',
    "\   '--enable=unconvert',
  else
    let g:ale_linters.go = [ 'gobuild', 'gofmt', 'golint', 'govet' ]
  endif
  let g:ale_fixers.go = [ 'goimports' ]

  let l:stylelintrc = fnamemodify(
        \   expand('$XDG_CONFIG_HOME/stylelint/stylelintrc.json'), ':p'
        \ )
  if filereadable(l:stylelintrc)
    let g:ale_css_stylelint_options = '--config ' . l:stylelintrc
  endif

  let l:tslintrc =
        \ fnamemodify(expand('$XDG_CONFIG_HOME/tslint/tslint.json'), ':p')
  if filereadable(l:tslintrc)
    let g:ale_typescript_tslint_config_path = l:tslintrc
  endif

  if executable(expand('$HOMEBREW_PREFIX/opt/php@5.6/bin/php'))
    let g:ale_php_php_executable = expand('$HOMEBREW_PREFIX/opt/php@5.6/bin/php')
  endif

endfunction "}}}
call s:ale_init()

Plug 'lambdalisue/suda.vim'

Plug 'Yggdroot/indentLine'
function! s:indent_line_init() abort "{{{
  let g:indentLine_faster = 1

  let g:indentLine_concealcursor = 'nc'
  let g:indentLine_conceallevel = 1
endfunction "}}}
call s:indent_line_init()

Plug 'editorconfig/editorconfig-vim'

" ================ Lazy ============================

Plug 'tyru/caw.vim', {
      \   'on': [ '<Plug>(caw' ],
      \ }
function! s:caw_vim_init() abort "{{{
  nmap gc <Plug>(caw:prefix)
  xmap gc <Plug>(caw:prefix)
endfunction "}}}
call s:caw_vim_init()

Plug 'lambdalisue/gina.vim', {
      \   'on': [ 'Gina' ],
      \ }
function! s:gina_vim_init() abort "{{{
  let g:gina#command#status#use_default_mappings = 0

  nnoremap <silent> <Leader>gs :<C-u>Gina status<CR>
  nnoremap <silent> <Leader>gb :<C-u>Gina branch<CR>
  nnoremap <silent> <Leader>gd :<C-u>Gina compare<CR>
endfunction "}}}
call s:gina_vim_init()
autocmd MyAutocmd User gina.vim
      \ execute 'source'
      \  fnamemodify(expand('$_VIMDIR/rc/plugins/gina.rc.vim'), ':p')

Plug 'Shougo/neomru.vim'

Plug 'Shougo/neco-vim', {
      \   'for': [ 'vim' ],
      \ }

Plug 'kana/vim-niceblock', {
      \   'on': [ '<Plug>(niceblock' ],
      \ }
function! s:vim_niceblock_init() abort "{{{
  xmap I <Plug>(niceblock-I)
  xmap A <Plug>(niceblock-A)
endfunction "}}}
call s:vim_niceblock_init()

if executable('lynx')
  Plug 'thinca/vim-ref', {
        \   'on': [ '<Plug>(ref-', 'Ref' ],
        \ }
  function! s:vim_ref_init() abort "{{{
    let g:ref_lynx_use_cache = 1
    let g:ref_lynx_start_linenumber = 0
    let g:ref_lynx_hide_url_number = 0
    let g:ref_cache_dir = fnamemodify(expand('$_CACHE/vim-ref'), ':p')

    nmap K <Plug>(ref-keyword)

    " for PHP
    let g:ref_phpmanual_path =
          \ fnamemodify(expand('$_CACHE/refs/php-chunked-xhtml'), ':p')
    let g:ref_phpmanual_cmd = 'lynx -dump -nonumbers -display_charset=utf-8 %s'

    autocmd MyAutocmd FileType ref nnoremap <silent> <buffer> q :<C-u>q<CR>
  endfunction "}}}
  call s:vim_ref_init()
endif

Plug 'yyotti/eskk.vim', {
      \   'branch': 'crvskkserv-support',
      \   'depends': [ 'vimproc.vim' ],
      \ }
function! s:eskk_vim_init() abort "{{{
  imap <C-j> <Plug>(eskk:toggle)
  cmap <C-j> <Plug>(eskk:toggle)

  let g:eskk#enable_completion = 0

  if !exists('g:eskk#directory')
    let g:eskk#directory = fnamemodify(expand('$_CACHE/eskk'), ':p')
  endif
  let g:eskk#show_annotation = 1

  " User dic
  let g:eskk#dictionary =
        \ fnamemodify(expand(g:eskk#directory . '/skk-jisyo'), ':p')

  let l:large_dic = ''
  if filereadable('/usr/share/skk/SKK-JISYO.L')
    let l:large_dic = '/usr/share/skk/SKK-JISYO.L'
  elseif filereadable('/usr/local/share/skk/SKK-JISYO.L')
    let l:large_dic = '/usr/local/share/skk/SKK-JISYO.L'
  endif

  if !empty(l:large_dic)
    let g:eskk#large_dictionary = {
          \   'path': l:large_dic,
          \   'sorted': 1,
          \   'encoding': 'euc-jp',
          \ }

  endif

  let l:host = filereadable('/.dockerenv') ?
       \ 'host.docker.internal' : 'localhost'
  " google-ime-skk
  if executable('google-ime-skk')
    let g:eskk#server = {
          \   'host': l:host,
          \   'port': 55100,
          \   'timeout': 1000,
          \ }
  else
    let g:eskk#server = {
          \   'host': l:host,
          \   'timeout': 1000,
          \   'last_cr': 0,
          \ }
  endif

  autocmd MyAutocmd User eskk-initialize-pre call EskkInitialPre()
endfunction "}}}
call s:eskk_vim_init()
function! EskkInitialPre() abort "{{{
  let l:t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
  call l:t.add_map('z ', "\u3000")
  call l:t.add_map('z(', "\uff08")
  call l:t.add_map('z)', "\uff09")
  call l:t.add_map('~', "\u301c")
  call eskk#register_mode_table('hira', l:t)
  unlet l:t
endfunction "}}}

Plug 'kana/vim-operator-replace', {
      \   'depends': [ 'vim-operator-user' ],
      \   'on': [ '<Plug>(operator-replace' ],
      \ }
function! s:vim_operator_replace_init() abort "{{{
  map R <Plug>(operator-replace)
  xmap p <Plug>(operator-replace)
endfunction "}}}
call s:vim_operator_replace_init()

Plug 'rhysd/vim-operator-surround', {
      \   'depends': [ 'vim-operator-user' ],
      \   'on': [ '<Plug>(operator-surround' ],
      \ }
function! s:vim_operator_surround_init() abort "{{{
  map <silent> ra <Plug>(operator-surround-append)
  map <silent> rd <Plug>(operator-surround-delete)
  map <silent> rc <Plug>(operator-surround-replace)
endfunction "}}}
call s:vim_operator_surround_init()

Plug 'airblade/vim-gitgutter', { 'on': [] }  " Force lazy
function! s:vim_gitgutter_init() abort "{{{
  let g:gitgutter_sign_added = s:gitgutter_sign_added
  let g:gitgutter_sign_modified = s:gitgutter_sign_modified
  let g:gitgutter_sign_removed = s:gitgutter_sign_removed
  let g:gitgutter_sign_removed_first_line = s:gitgutter_sign_removed
  let g:gitgutter_sign_modified_removed = s:gitgutter_sign_modified

  " Disable default mappings
  let g:gitgutter_map_keys = 0
endfunction "}}}
call s:vim_gitgutter_init()
autocmd MyAutocmd User vim-gitgutter call <SID>vim_gitgutter_loaded()
function! s:vim_gitgutter_loaded() abort "{{{
  autocmd MyAutocmd BufEnter * call <SID>gitgutter_mapping()
  function! s:gitgutter_mapping() abort "{{{
    if !hasmapto('<Plug>(GitGutterPrevHunk)') && maparg('[c', 'n') ==# ''
      nmap <buffer> [c <Plug>(GitGutterPrevHunk)
    endif
    if !hasmapto('<Plug>(GitGutterNextHunk)') && maparg(']c', 'n') ==# ''
      nmap <buffer> ]c <Plug>(GitGutterNextHunk)
    endif
    if !hasmapto('<Plug>(GitGutterPreviewHunk)')
          \ && maparg('<Leader>p', 'n') ==# ''
      nmap <buffer> <Leader>gp <Plug>(GitGutterPreviewHunk)
    endif

    if !hasmapto('<Plug>(GitGutterTextObjectInnerPending)')
          \ && maparg('ic', 'o') ==# ''
      omap <buffer> ic <Plug>(GitGutterTextObjectInnerPending)
    endif
    if !hasmapto('<Plug>(GitGutterTextObjectOuterPending)')
          \ && maparg('ac', 'o') ==# ''
      omap <buffer> ac <Plug>(GitGutterTextObjectOuterPending)
    endif
    if !hasmapto('<Plug>(GitGutterTextObjectInnerVisual)')
          \ && maparg('ic', 'x') ==# ''
      xmap <buffer> ic <Plug>(GitGutterTextObjectInnerVisual)
    endif
    if !hasmapto('<Plug>(GitGutterTextObjectOuterVisual)')
          \ && maparg('ac', 'x') ==# ''
      xmap <buffer> ac <Plug>(GitGutterTextObjectOuterVisual)
    endif
  endfunction "}}}

  highlight link GitGutterAdd diffAdded
  highlight link GitGutterDelete diffRemoved
  highlight link GitGutterChange qfLineNr
  highlight link GitGutterChangeDelete GitGutterChange
endfunction "}}}
augroup load_vim_gitgutter
  autocmd!
  autocmd VimEnter *
        \ call plug#load('vim-gitgutter')
        \|autocmd! load_vim_gitgutter
augroup END

Plug 'easymotion/vim-easymotion', {
      \   'depends': [ 'vim-repeat' ],
      \   'on': [ '<Plug>(easymotion' ],
      \ }
function! s:vim_easymotion_init() abort "{{{
  map ' <Plug>(easymotion-prefix)

  map f <Plug>(easymotion-fl)
  map t <Plug>(easymotion-tl)
  map F <Plug>(easymotion-Fl)
  map T <Plug>(easymotion-Tl)

  map g/ <Plug>(easymotion-sn)
  map g? <Plug>(easymotion-sn)

  " map ; <Plug>(easymotion-next)

  map 'f <Plug>(easymotion-fln)
  map 't <Plug>(easymotion-tln)
  map 'F <Plug>(easymotion-Fln)
  map 'T <Plug>(easymotion-Tln)

  let g:EasyMotion_smartcase = 1
  let g:EasyMotion_enter_jump_first = 1
  let g:EasyMotion_space_jump_first = 1
  let g:EasyMotion_startofline = 0
  let g:EasyMotion_verbose = 0
endfunction "}}}
call s:vim_easymotion_init()

Plug 'simeji/winresizer', {
      \   'on': [ 'WinResizerStartResize' ],
      \ }
function! s:winresizer_init() abort "{{{
  nnoremap <C-w>r :<C-u>WinResizerStartResize<CR>
endfunction "}}}
call s:winresizer_init()
autocmd MyAutocmd User winresizer call <SID>winresizer_loaded()
function! s:winresizer_loaded() abort "{{{
  let g:winresizer_vert_resize = 5
  if exists('g:winresizer_start_key')
    execute 'silent! unmap' g:winresizer_start_key
    unlet g:winresizer_start_key
  endif
  if exists('g:winresizer_gui_start_key')
    execute 'silent! unmap' g:winresizer_gui_start_key
    unlet g:winresizer_gui_start_key
  endif
endfunction "}}}

Plug 'thinca/vim-quickrun', {
      \   'on': [ '<Plug>(quickrun' ],
      \ }
function! s:vim_quickrun_init() abort "{{{
  nmap <silent> <Leader>r <Plug>(quickrun)
endfunction "}}}
call s:vim_quickrun_init()

Plug 'yyotti/vim-autoupload', {
      \   'for': [ 'php', 'smarty', 'css', 'js' ],
      \ }
function! s:vim_autoupload_init() abort "{{{
  " TODO hook_source ...
  autocmd MyAutocmd BufWinEnter *.php,*.tpl,*.css,*.js
        \ call autoupload#init(0)
  autocmd MyAutocmd BufWritePost *.php,*.tpl,*.css,*.js
        \ call autoupload#upload(0)
endfunction "}}}
call s:vim_autoupload_init()

Plug 'benjifisher/matchit.zip', { 'on': [] }  " Force lazy
augroup load_matchit
  autocmd!
  autocmd VimEnter *
        \ if exists('g:loaded_matchit')
        \|  unlet g:loaded_matchit
        \|endif
        \|call plug#load('matchit.zip')
        \|autocmd! load_matchit
augroup END

Plug 'osyo-manga/vim-precious', {
      \   'depends': [ 'context_filetype.vim' ],
      \   'on': [ 'PreciousSwitch', 'PreciousReset' ],
      \ }
function! s:vim_precious_init() abort "{{{
  autocmd MyAutocmd InsertEnter * PreciousSwitch
  autocmd MyAutocmd InsertLeave * PreciousReset

  let g:precious_enable_switch_CursorMoved = { '*': 0 }
endfunction "}}}
call s:vim_precious_init()

Plug 'AndrewRadev/linediff.vim', {
      \   'on': [ 'Linediff' ],
      \ }
function! s:linediff_vim_init() abort "{{{
  " Only visual mode
  xnoremap <silent> D :Linediff<CR>
endfunction "}}}
call s:linediff_vim_init()

if executable('go') && 0
  " to use GoFmt/GoImport
  Plug 'fatih/vim-go', {
        \   'do': ':GoInstallBinaries',
        \   'for': [ 'go', 'gohtmltmpl' ],
        \ }
  function! s:vim_go_init() abort "{{{
    let g:go_fmt_fail_silently = 1
    let g:go_highlight_types = 1
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_operators = 1
    let g:go_def_mapping_enabled = 0
  endfunction "}}}
  call s:vim_go_init()
endif

Plug 'Shougo/defx.nvim', {
      \   'do': ':UpdateRemotePlugins',
      \   'on': [ 'Defx' ],
      \ }
function! s:defx_nvim_init() abort "{{{
  nnoremap <silent> <Leader>fe
        \ :<C-u>Defx -buffer-name=defx <C-r>=expand('%:p:h')<CR>
        \   -search=<C-r>=expand('%:p')<CR><CR>
endfunction "}}}
call s:defx_nvim_init()

Plug '/home/linuxbrew/.linuxbrew/opt/fzf'
Plug 'junegunn/fzf.vim'
function! s:fzf_init() abort "{{{
  execute 'source' fnamemodify(expand('$_VIMDIR/rc/plugins/fzf.rc.vim'), ':p')
endfunction "}}}
call s:fzf_init()

" ================ Local plugins ============================

let s:local_vimplug = fnamemodify(expand('$HOME/.vimplug.vim'), ':p')
if filereadable(s:local_vimplug)
  execute 'source' s:local_vimplug
endif

call plug#end()
