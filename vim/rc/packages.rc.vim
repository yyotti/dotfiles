command! ShowRtp call s:show_rtp()
function! s:show_rtp() abort "{{{
  for l:rtp in split(&runtimepath, ',')
    echo l:rtp
  endfor
endfunction "}}}

call pack#init()

" vim-css3-syntax {{{
call pack#add('hail2u/vim-css3-syntax')
" }}}

" vim-toml {{{
call pack#add('cespare/vim-toml')
" }}}

" vim-json {{{
let s:pack = pack#add('elzr/vim-json')
function! s:pack.init() abort "{{{
  let g:vim_json_syntax_conceal = 0
endfunction "}}}
unlet s:pack
" }}}

" vim-markdown {{{
call pack#add('rcmdnk/vim-markdown')
" }}}

" vim-python-pep8-indent {{{
call pack#add('Vimjas/vim-python-pep8-indent')
" }}}

" smarty-syntax {{{
call pack#add('vim-scripts/smarty-syntax')
" }}}

" html5.vim {{{
call pack#add('othree/html5.vim')
" }}}

" scss-syntax.vim {{{
call pack#add('cakebaker/scss-syntax.vim')
" }}}

" vim-blade {{{
call pack#add('jwalton512/vim-blade')
" }}}

" lightline.vim {{{
let s:pack = pack#add('itchyny/lightline.vim', {
      \   'enabled': v:false,
      \ })
function! s:pack.init() abort "{{{
  source $VIMDIR/rc/plugins/lightline.rc.vim
endfunction "}}}
unlet s:pack
" }}}

" vim-airline {{{

let s:pack = pack#add('vim-airline/vim-airline')
function! s:pack.init() abort "{{{
  let g:airline_skip_empty_sections = 1

  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif

  let g:airline_symbols.maxlinenr = ''
  if !IsWindows()
    let g:airline_left_sep = "\u2b80"
    let g:airline_left_alt_sep = "\u2b81"
    let g:airline_right_sep = "\u2b82"
    let g:airline_right_alt_sep = "\u2b83"

    let g:airline_symbols.linenr = "\u2b61"
    let g:airline_symbols.readonly = "\u2b64"
    let g:airline_symbols.branch = "\u2b60"
  else
    let g:airline_symbols.linenr = 'L'
    let g:airline_symbols.readonly = '[R]'
  endif

  " Extension settings
  " ALE "{{{
  let g:airline#extensions#ale#error_symbol = 'E'
  let g:airline#extensions#ale#warning_symbol = 'W'
  "}}}

  " Hunks "{{{
  if pack#has('airblade/vim-gitgutter')
    let g:airline#extensions#hunks#non_zero_only = 1
    let g:airline#extensions#hunks#hunk_symbols = [
          \   g:gitgutter_sign_added,
          \   g:gitgutter_sign_modified,
          \   g:gitgutter_sign_removed,
          \ ]
  endif
  "}}}
endfunction "}}}
function! s:pack.added() abort "{{{
  function! EskkMode() abort "{{{
    return exists('*eskk#statusline') && !empty(eskk#statusline()) ?
          \ matchlist(eskk#statusline(), '^\[eskk:\(.\+\)\]$')[1] : ''
  endfunction "}}}
  call airline#parts#define_function('eskk', 'EskkMode')
  call airline#parts#define('lineinfo', {
        \   'raw': ' %3v %{g:airline_symbols.linenr}%3l/%L',
        \ })

  autocmd MyAutocmd User AirlineAfterInit call s:airline_init()
  function! s:airline_init() abort "{{{
    let l:section_b = []
    call add(l:section_b, 'hunks')

    if pack#has('lambdalisue/gina.vim')
      call add(l:section_b, '%{gina#component#repo#branch()}')
    endif

    let g:airline_section_a = airline#section#create_left([ 'mode', 'eskk' ])
    let g:airline_section_b = airline#section#create(l:section_b)
    let g:airline_section_z = airline#section#create([ 'windowswap', 'obsession', 'lineinfo' ])
  endfunction "}}}
endfunction "}}}
unlet s:pack

" vim-airline-themes should be loaded after vim-airline
call pack#add('vim-airline/vim-airline-themes', {
      \   'depends': [ 'vim-airline/vim-airline' ],
      \ })

" }}}

" vim-hybrid {{{
call pack#add('w0ng/vim-hybrid')
" }}}

" haskell-vim {{{
let s:pack = pack#add('neovimhaskell/haskell-vim')
function! s:pack.init() abort "{{{
  let g:haskell_indent_disable = 1
endfunction "}}}
unlet s:pack
" }}}

" vim-haskell-indent {{{
call pack#add('itchyny/vim-haskell-indent')
" }}}

" vim-ps1 {{{
call pack#add('PProvost/vim-ps1')
" }}}

" vim-textobj-user {{{
call pack#add('kana/vim-textobj-user')
" }}}

" vim-operator-user {{{
call pack#add('kana/vim-operator-user')
" }}}

" neosnippet-snippets {{{
call pack#add('Shougo/neosnippet-snippets')
" }}}

" vim-repeat {{{
call pack#add('tpope/vim-repeat')
" }}}

" neomru.vim {{{
call pack#add('Shougo/neomru.vim')
" }}}

" context_filetype.vim {{{
call pack#add('Shougo/context_filetype.vim')
" }}}

" vimdoc-ja {{{
call pack#add('vim-jp/vimdoc-ja')
" }}}

" vim-parenmatch {{{
call pack#add('itchyny/vim-parenmatch', {
      \   'enabled': v:version == 704 && has('patch786')
      \               || v:version >= 705
      \               || has('nvim')
      \})
" }}}

" caw.vim {{{
let s:pack = pack#add('tyru/caw.vim')
function! s:pack.init() abort "{{{
  nmap gc <Plug>(caw:prefix)
  xmap gc <Plug>(caw:prefix)
endfunction "}}}
unlet s:pack
" }}}

" vim-fugitive {{{
let s:pack = pack#add('tpope/vim-fugitive', {
      \   'enabled': v:false,
      \ })
function! s:pack.init() abort "{{{
  nnoremap <silent> <Leader>gs :<C-u>Gstatus<CR>
  nnoremap <silent> <Leader>gd :<C-u>Gvdiff<CR>
endfunction "}}}
function! s:pack.added() abort "{{{
  source $VIMDIR/rc/plugins/vim-fugitive.rc.vim
endfunction "}}}
unlet s:pack
" }}}

" gina.vim {{{
let s:pack = pack#add('lambdalisue/gina.vim')
function! s:pack.init() abort "{{{
  " Disable default mappings
  let g:gina#command#status#use_default_mappings = 0

  nnoremap <silent> <Leader>gs :<C-u>Gina status -s<CR>
  noremap <silent> <Leader>gd :<C-u>Gina compare<CR>
endfunction "}}}
function! s:pack.added() abort "{{{
  " TODO
  " source $VIMDIR/rc/plugins/vim-fugitive.rc.vim

  " status {{{
  call gina#custom#mapping#nmap('status', '<CR>',
        \ ':call gina#action#call(''edit'')<CR>',
        \ { 'noremap': 1, 'silent': 1})

  call gina#custom#mapping#nmap('status', 'D',
        \ ':call gina#action#call(''compare:tab'')<CR>',
        \ { 'noremap': 1, 'silent': 1})

  call gina#custom#mapping#map('status', '-',
        \ '<Plug>(gina-index-toggle)', { 'silent': 1})

  call gina#custom#mapping#map('status', 'C', ':Gina commit<CR>')
  call gina#custom#mapping#map('status', 'cn', ':Gina now --stat<CR>')
  call gina#custom#mapping#map('status', 'ca', ':Gina commit --amend<CR>')

  call gina#custom#mapping#nmap('status', 'U',
        \ ':call gina#action#call(''checkout'')<CR>',
        \ { 'noremap': 1, 'silent': 1})

  call gina#custom#mapping#map('status', '<C-n>', '<Plug>(gina-builtin-mark)j')
  call gina#custom#mapping#map('status', '<C-p>', '<Plug>(gina-builtin-mark)k')
  " }}}

  " Disable builtin mappings
  call gina#custom#mapping#map('/.*', 'mm', '<Nop>')
  call gina#custom#mapping#map('/.*', 'm+', '<Nop>')
  call gina#custom#mapping#map('/.*', 'm-', '<Nop>')
  call gina#custom#mapping#map('/.*', 'm*', '<Nop>')

  " Remapping <C-j>/<C-k>
  call gina#custom#mapping#map('/.*', '<C-j>', '<C-w>j')
  call gina#custom#mapping#map('/.*', '<C-k>', '<C-w>k')

  " Close
  call gina#custom#mapping#nmap('/.*', 'q', ':q<CR>',
        \ { 'noremap': 1, 'silent': 1})
endfunction "}}}
unlet s:pack
" }}}

" neosnippet.vim {{{
let s:pack = pack#add('Shougo/neosnippet.vim', {
      \   'depends': [
      \     'Shougo/neosnippet-snippets',
      \     'Shougo/context_filetype.vim',
      \   ],
      \ })
function! s:pack.init() abort "{{{
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
unlet s:pack
" }}}

" denite.nvim {{{
let s:pack = pack#add('Shougo/denite.nvim', {
      \   'enabled': has('nvim') || v:version >= 800 && has('python3'),
      \   'depends': [ 'Shougo/neomru.vim' ],
      \ })
function! s:pack.init() abort "{{{
  nnoremap <silent> ,b :<C-u>Denite buffer file_old<CR>
  nnoremap <silent> ,f :<C-u>Denite file_rec<CR>
  nnoremap <silent> ,l :<C-u>Denite line<CR>
  nnoremap <silent> ,g
        \ :<C-u>Denite grep -mode=normal -no-empty -buffer-name=grep<CR>
  nnoremap <silent> <Leader>ur
        \ :<C-u>Denite -resume -mode=normal -no-empty -buffer-name=grep<CR>
  nnoremap <silent> <Leader>ue :<C-u>Denite menu:_<CR>
  " nnoremap <silent> <Leader>uc :<C-u>Denite command_history command<CR>

  nnoremap <silent> ,n
        \ :<C-u>Denite -resume -select=+1 -immediately -buffer-name=grep<CR>
  nnoremap <silent> ,p
        \ :<C-u>Denite -resume -select=-1 -immediately -buffer-name=grep<CR>

endfunction "}}}
function! s:pack.added() abort "{{{
  source $VIMDIR/rc/plugins/denite.rc.vim
endfunction "}}}
unlet s:pack
" }}}

" vaffle.vim {{{
let s:pack = pack#add('cocopon/vaffle.vim', {
      \   'enabled': v:version >= 800 || has('nvim')
      \ })
function! s:pack.init() abort "{{{
  let g:vaffle_use_default_mappings = 0

  nnoremap <silent> <Leader>fe :<C-u>Vaffle <C-r>=expand('%:h')<CR><CR>

  " TODO Use Vaffle as default file explorer

  autocmd MyAutocmd FileType vaffle call <SID>vaffle_mappings()
  function! s:vaffle_mappings() abort "{{{
    nmap <buffer> h <Plug>(vaffle-open-parent)
    nmap <buffer> l <Plug>(vaffle-open-current)
    nmap <buffer> <CR> <Plug>(vaffle-open-selected)

    nmap <buffer> <nowait> q <Plug>(vaffle-quit)
    nmap <buffer> <nowait> R <Plug>(vaffle-refresh)
    nmap <buffer> <nowait> . <Plug>(vaffle-toggle-hidden)

    nmap <buffer> <nowait> <Space> <Plug>(vaffle-toggle-current)
    vmap <buffer> <nowait> <Space> <Plug>(vaffle-toggle-current)
    nmap <buffer> <nowait> * <Plug>(vaffle-all)

    nmap <buffer> <nowait> K <Plug>(vaffle-mkdir)
    nmap <buffer> <nowait> N <Plug>(vaffle-new-file)
    nmap <buffer> <nowait> d <Plug>(vaffle-delete-selected)
    nmap <buffer> <nowait> m <Plug>(vaffle-move-selected)
    nmap <buffer> <nowait> r <Plug>(vaffle-rename-selected)
  endfunction "}}}
endfunction "}}}
unlet s:pack
" }}}

" junkfile.vim {{{
let s:pack = pack#add('Shougo/junkfile.vim', {
      \   'depends': [ 'Shougo/denite.nvim' ],
      \ })
function! s:pack.init() abort "{{{
  nnoremap <silent> <Leader>uj :<C-u>Denite junkfile:new junkfile<CR>
endfunction "}}}
unlet s:pack
" }}}

" neco-vim {{{
call pack#add('Shougo/neco-vim')
" }}}

" vim-niceblock {{{
let s:pack = pack#add('kana/vim-niceblock')
function! s:pack.init() abort "{{{
  xmap I <Plug>(niceblock-I)
  xmap A <Plug>(niceblock-A)
endfunction "}}}
unlet s:pack
" }}}

" neco-vim {{{
call pack#add('LeafCage/foldCC.vim')
" }}}

" vim-ref {{{
let s:pack = pack#add('thinca/vim-ref', {
      \   'enabled': executable('lynx'),
      \   'build': [ [ '~/.vim/script/phpmanual-install.sh' ] ],
      \ })
function! s:pack.init() abort "{{{
  nmap K <Plug>(ref-keyword)

  if IsWindows()
    let g:ref_refe_encoding = 'cp932'
  endif

  let g:ref_lynx_use_cache = 1
  let g:ref_lynx_start_linenumber = 0
  let g:ref_lynx_hide_url_number = 0

  " PHP
  let g:ref_phpmanual_path =
        \ vimrc#join_path($HOME, '.vim/refs/php-chunked-xhtml')

  autocmd MyAutocmd FileType ref nnoremap <silent> <buffer> q :q<CR>
endfunction "}}}
unlet s:pack
" }}}

" vimproc.vim {{{
call pack#add('Shougo/vimproc.vim', {
      \   'enabled': !IsWindows(),
      \   'build': [ [ 'make' ] ],
      \ })
" }}}

" eskk.vim {{{
let s:pack = pack#add('yyotti/eskk.vim')
function! s:pack.init() abort "{{{
  imap <C-j> <Plug>(eskk:toggle)
  cmap <C-j> <Plug>(eskk:toggle)

  let g:eskk#enable_completion = 0

  if !exists('g:eskk#directory')
    " TODO $XDG_DATA_HOME/vim/eskk
    let g:eskk#directory = expand('~/.eskk')
  endif
  let g:eskk#show_annotation = 1

  " User dic
  let g:eskk#dictionary = g:eskk#directory . '/skk-jisyo'

  let l:large_dic = ''
  if filereadable('/usr/share/skk/SKK-JISYO.L')
    let l:large_dic = '/usr/share/skk/SKK-JISYO.L'
  elseif filereadable('/usr/local/share/skk/SKK-JISYO.L')
    let l:lerge_dic = '/usr/share/skk/SKK-JISYO.L'
  endif

  if !empty(l:large_dic)
    let g:eskk#large_dictionary = {
          \   'path': l:large_dic,
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
          \   'last_cr': 0,
          \ }
  endif

  autocmd MyAutocmd User eskk-initialize-pre call s:eskk_initial_pre()
  function! s:eskk_initial_pre() abort "{{{
    let l:t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
    call l:t.add_map('z ', "\u3000")
    call l:t.add_map('z(', "\uff08")
    call l:t.add_map('z)', "\uff09")
    call l:t.add_map('~', "\u301c")
    call eskk#register_mode_table('hira', l:t)
    unlet l:t
  endfunction "}}}
endfunction "}}}
unlet s:pack
" }}}

" open-browser.vim {{{
call pack#add('tyru/open-browser.vim')
" }}}

" vim-operator-replace {{{
let s:pack = pack#add('kana/vim-operator-replace', {
      \   'depends': [ 'kana/vim-operator-user' ],
      \ })
function! s:pack.init() abort "{{{
  map R <Plug>(operator-replace)
  xmap p <Plug>(operator-replace)
endfunction "}}}
unlet s:pack
" }}}

" vim-operator-surround {{{
let s:pack = pack#add('rhysd/vim-operator-surround', {
      \   'depends': [ 'kana/vim-operator-user' ],
      \ })
function! s:pack.init() abort "{{{
  map <silent> ra <Plug>(operator-surround-append)
  map <silent> rd <Plug>(operator-surround-delete)
  map <silent> rc <Plug>(operator-surround-replace)
endfunction "}}}
unlet s:pack
" }}}

" vim-gitgutter {{{
let s:pack = pack#add('airblade/vim-gitgutter')
function! s:pack.init() abort "{{{
  let g:gitgutter_sign_added = 'A'
  let g:gitgutter_sign_modified = 'M'
  let g:gitgutter_sign_removed = 'D'
  let g:gitgutter_sign_modified_removed = 'MD'

  let g:gitgutter_map_keys = 0
  let g:gitgutter_async = 0

  nmap [c <Plug>GitGutterPrevHunkzvzz
  nmap ]c <Plug>GitGutterNextHunkzvzz
endfunction "}}}
unlet s:pack
" }}}

" vim-easymotion {{{
let s:pack = pack#add('easymotion/vim-easymotion', {
      \   'depends': [ 'tpope/vim-repeat' ],
      \ })
function! s:pack.init() abort "{{{
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

  map g/ <Plug>(easymotion-sn)
  map g# <Plug>(easymotion-sn)

  map ; <Plug>(easymotion-next)

  map 'f <Plug>(easymotion-fln)
  map 't <Plug>(easymotion-tln)
  map 'F <Plug>(easymotion-Fln)
  map 'T <Plug>(easymotion-Tln)
endfunction "}}}
unlet s:pack
" }}}

" sudo.vim {{{
call pack#add('vim-scripts/sudo.vim', {
      \   'enabled': !IsWindows(),
      \ })
" }}}

" agit.vim {{{
let s:pack = pack#add('cohama/agit.vim', {
      \   'enabled': 0,
      \ })
function! s:pack.init() abort "{{{
  nnoremap <silent> <Leader>ga :<C-u>Agit<CR>
  nnoremap <silent> <Leader>gf :<C-u>AgitFile<CR>
endfunction "}}}
unlet s:pack
" }}}

" winresizer {{{
let s:pack = pack#add('simeji/winresizer')
function! s:pack.init() abort "{{{
  if has('gui_running')
    let g:winresizer_gui_enable = 1
    nnoremap <C-w>R :<C-u>WinResizerStartResizeGUI<CR>
  endif

  let g:winresizer_vert_resize = 5
  nnoremap <C-w>r :<C-u>WinResizerStartResize<CR>
endfunction "}}}
function! s:pack.added() abort "{{{
  if exists('g:winresizer_start_key')
    execute 'silent! unmap' g:winresizer_start_key
    if has('gui_running')
      execute 'silent! unmap' g:winresizer_gui_start_key
    endif
  endif
endfunction "}}}
unlet s:pack
" }}}

" ale {{{
let s:pack = pack#add('w0rp/ale', {
      \   'enabled': has('nvim') ||
      \               has('job') && has('channel') && has('timers')
      \ })
function! s:pack.init() abort "{{{
  let g:ale_lint_on_enter = 0
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
  if executable('gometalinter')
    let g:ale_linters.go = [ 'gometalinter' ]
    let g:ale_go_gometalinter_options = join([
          \   '--tests',
          \   '--fast',
          \   '--enable=megacheck',
          \   '--enable=errcheck',
          \   '--enable=deadcode',
          \ ])
          " \   '--enable=interfacer',
          " \   '--enable=misspell',
          " \   '--enable=unconvert',
  else
    let g:ale_linters.go = [ 'go build', 'gofmt', 'golint', 'go vet' ]
  endif
endfunction "}}}
unlet s:pack
" }}}

" vim-quickrun {{{
let s:pack = pack#add('thinca/vim-quickrun')
function! s:pack.init() abort "{{{
  nmap <silent> <Leader>r <Plug>(quickrun)
endfunction "}}}
unlet s:pack
" }}}

" vim-operator-flashy {{{
let s:pack = pack#add('haya14busa/vim-operator-flashy', {
      \   'depends': [ 'kana/vim-operator-user' ],
      \ })
function! s:pack.init() abort "{{{
  let g:operator#flashy#flash_time = 300

  map y <Plug>(operator-flashy)
  nmap Y <Plug>(operator-flashy)$
endfunction "}}}
function! s:pack.added() abort "{{{
  highlight Flashy ctermbg=8 guibg=#666666
endfunction "}}}
unlet s:pack
" }}}

" vim-autoupload {{{
let s:pack = pack#add('yyotti/vim-autoupload')
function! s:pack.init() abort "{{{
  autocmd MyAutocmd BufWinEnter *.php,*.tpl,*.css,*.js
        \ call autoupload#init(0)
  autocmd MyAutocmd BufWritePost *.php,*.tpl,*.css,*.js
        \ call autoupload#upload(0)
endfunction "}}}
unlet s:pack
" }}}

" matchit.zip {{{
let s:pack = pack#add('benjifisher/matchit.zip')
function! s:pack.init() abort "{{{
  if exists('g:loaded_matchit')
    unlet g:loaded_matchit
  endif
endfunction "}}}
unlet s:pack
" }}}

" vim-precious {{{
let s:pack = pack#add('osyo-manga/vim-precious', {
      \   'depends': [ 'Shougo/context_filetype.vim' ],
      \ })
function! s:pack.init() abort "{{{
  let g:precious_enable_switch_CursorMoved = { '*': 0 }
  autocmd MyAutocmd InsertEnter * PreciousSwitch
  autocmd MyAutocmd InsertLeave * PreciousReset
endfunction "}}}
unlet s:pack
" }}}

" vim-php-refactoring-toolbox {{{
let s:pack = pack#add('adoy/vim-php-refactoring-toolbox')
function! s:pack.init() abort "{{{
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
unlet s:pack
" }}}

" linediff.vim {{{
let s:pack = pack#add('AndrewRadev/linediff.vim')
function! s:pack.init() abort "{{{
  " Only visual mode
  xnoremap <silent> D :Linediff<CR>
endfunction "}}}
unlet s:pack
" }}}

" securemodelines {{{
let s:pack = pack#add('ciaranm/securemodelines')
function! s:pack.init() abort "{{{
  set modelines=0
  set nomodeline
endfunction "}}}
unlet s:pack
" }}}

" vim-go {{{
let s:pack = pack#add('fatih/vim-go', {
      \   'enabled': executable('go'),
      \ })
function! s:pack.init() abort "{{{
  let g:go_fmt_fail_silently = 1
endfunction "}}}
function! s:pack.added() abort "{{{
  " TODO
  if !executable('gocode')
    GoInstallBinaries
  endif

  execute 'set runtimepath+=' .
        \ globpath($GOPATH, 'src/github.com/nsf/gocode/vim')
endfunction "}}}
unlet s:pack
" }}}

" jedi-vim {{{
let s:pack = pack#add('davidhalter/jedi-vim', {
      \   'enabled': (has('python') || has('python3')) && executable('python'),
      \   'build': [ [ 'git', 'submodule', '--quiet', 'update', '--init' ] ],
      \ })
function! s:pack.init() abort "{{{
  let g:jedi#auto_initialization = 0
  let g:jedi#popup_select_first = 0
  let g:jedi#popup_on_dot = 0
  let g:jedi#auto_vim_configuration = 0
  let g:jedi#show_call_signatures = 0
  let g:jedi#completions_enabled = 0
  let g:jedi#smart_auto_mappings = 0

  if has('python3')
    let g:jedi#force_py_version = 3
  endif
endfunction "}}}
unlet s:pack
" }}}

" neosnippet-php {{{
call pack#add('yyotti/neosnippet-php.vim', {
      \   'depends': [ 'Shougo/neosnippet.vim' ],
      \   'build': [
      \     [ fnamemodify('~/.vim/script/phpmanual-install.sh', ':p') ],
      \     [ 'php', 'install.php', '-d"$HOME/.vim/refs/php-chunked-xhtml"' ],
      \   ],
      \ })
" }}}

" neco-ghc {{{
call pack#add('eagletmt/neco-ghc')
" external_commands = 'ghc-mod' " TODO
" }}}

" yapf {{{
let s:pack = pack#add('google/yapf')
function! s:pack.init() abort "{{{
  " TODO
  " nmap <LocalLeader>f :1,$call yapf#YAPF()<CR>
  " autocmd MyAutocmd BufWritePre *.py call yapf#YAPF()
endfunction "}}}
unlet s:pack
" }}}

" deoplete.nvim {{{
" Only for Vim8
call pack#add('roxma/nvim-yarp', {
      \   'enabled': !has('nvim') && v:version >= 800 && has('python3'),
      \ })
call pack#add('roxma/vim-hug-neovim-rpc', {
      \   'enabled': !has('nvim') && v:version >= 800 && has('python3'),
      \ })

let s:pack = pack#add('Shougo/deoplete.nvim', {
      \   'enabled': has('python3'),
      \   'depends': [
      \     'Shougo/context_filetype.vim',
      \   ],
      \ })
function! s:pack.init() abort "{{{
  let g:deoplete#enable_at_startup = 1
endfunction "}}}
function! s:pack.added() abort "{{{
  source $VIMDIR/rc/plugins/deoplete.rc.vim
endfunction "}}}
unlet s:pack
" }}}

" deoplete-go {{{
call pack#add('zchee/deoplete-go', {
      \   'enabled': executable('go'),
      \   'depends': [ 'Shougo/deoplete.nvim' ],
      \   'build': [
      \     [ 'go', 'get', '-u', 'github.com/nsf/gocode' ],
      \     [ 'make' ],
      \   ],
      \ })
" }}}

" deoplete-jedi {{{
call pack#add('zchee/deoplete-jedi', {
      \   'enabled': (has('python') || has('python3')) && executable('python'),
      \   'depends': [ 'Shougo/deoplete.nvim' ],
      \   'build': [ [ 'git', 'submodule', '--quiet', 'update', '--init' ] ],
      \ })
" }}}

" indentLine {{{
let s:pack = pack#add('Yggdroot/indentLine')
function! s:pack.init() abort "{{{
  let g:indentLine_faster = 1

  " let g:indentLine_color_gui = '#ffff00'
  " let g:indentLine_bgcolor_gui = '#ff5f00'

  let g:indentLine_concealcursor = 'nc'
  let g:indentLine_conceallevel = 1
endfunction "}}}
unlet s:pack
" }}}

" denite-marks {{{
let s:pack = pack#add('yyotti/denite-marks', {
      \   'depends': [ 'Shougo/denite.nvim' ],
      \ })
function! s:pack.init() abort "{{{
  nnoremap <silent> ,m :<C-u>Denite marks<CR>
endfunction "}}}
unlet s:pack
" }}}

" TODO Pending {{{
" TODO ???
" [[plugins]]
" repo = 'nsf/gocode'
" rtp = 'vim'

" [[plugins]]
" repo = 'syngan/vim-vimlint'
" if = '!executable("vimlparser")'
" depends = [ 'vim-vimlparser' ]
"
" [[plugins]]
" repo = 'ynkdir/vim-vimlparser'
" if = '!executable("vimlparser")'

" }}}

" Install plugins {{{
function! s:check_install() abort " {{{
  let l:packages = pack#check_install()
  if empty(l:packages)
    return
  endif

  let l:msg = printf('%d packages are not installed. Install now ?',
        \ len(l:packages))
  if confirm(l:msg, "&Yes\n&No", 2) ==# 1
    call pack#install(l:packages)
  endif
endfunction " }}}

call s:check_install()
" }}}

call pack#end()
