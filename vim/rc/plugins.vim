scriptencoding utf-8
"--------------------------------------------------------------------------------
" plugins.vim
"

function! s:fpath(fname) abort
  return RcDir() . '/plugins/' . a:fname
endfunction

if neobundle#tap('neocomplete.vim') " {{{
  " neocompleteを有効化
  let g:neocomplete#enable_at_startup = 1

  let neobundle#hooks.on_source = s:fpath('neocomplete.vim')

  call neobundle#untap()
endif " }}}

if neobundle#tap('neosnippet.vim') " {{{
  let neobundle#hooks.on_source = s:fpath('neosnippet.vim')

  call neobundle#untap()
endif " }}}

if neobundle#tap('unite.vim') " {{{
  " マッピング {{{
  " prefix定義
  nnoremap [unite] <Nop>
  xnoremap [unite] <Nop>
  nmap <Leader>u [unite]
  xmap <Leader>u [unite]

  " バッファ一覧+mru
  nnoremap <silent> [unite]b :<C-u>Unite buffer file_mru<CR>
  " mruのみ
  nnoremap <silent> [unite]u :<C-u>Unite file_mru<CR>
  " ブックマーク一覧
  nnoremap <silent> [unite]m :<C-u>Unite bookmark<CR>
  " バッファ内で行を検索
  nnoremap <silent> [unite]l :<C-u>Unite line<CR>
  " grep
  nnoremap <silent> [unite]g :<C-u>Unite grep -buffer-name=grep -no-start-insert -auto-preview -no-empty<CR>
  " grep用のresume
  nnoremap <silent> [unite]r :<C-u>UniteResume -buffer-name=grep -no-start-insert -auto-preview -no-empty grep<CR>
  " }}}

  " ステータスラインを強制的に書き換えるのを抑止する
  let g:unite_force_overwrite_statusline = 0

  let neobundle#hooks.on_source = s:fpath('unite.vim')

  call neobundle#untap()
endif " }}}

if neobundle#tap('vimfiler.vim') " {{{
  " マッピング {{{
  " prefix定義
  nnoremap [vimfiler] <Nop>
  xnoremap [vimfiler] <Nop>
  nmap <Leader>f [vimfiler]
  xmap <Leader>f [vimfiler]

  " 現在開いているバッファのディレクトリを開く
  nnoremap <silent> [vimfiler]e :<C-u>VimFilerBufferDir -invisible<CR>
  " 現在開いているバッファをIDE風に開く
  nnoremap <silent> [vimfiler]i :<C-u>VimFilerExplorer -split -winwidth=40 -find -no-quit<CR>
  " }}}

  let neobundle#hooks.on_source = s:fpath('vimfiler.vim')

  call neobundle#untap()
endif " }}}

if neobundle#tap('eskk.vim') " {{{
  let neobundle#hooks.on_source = s:fpath('eskk.vim')

  call neobundle#untap()
endif " }}}

if neobundle#tap('unite-quickfix') " {{{
  nnoremap <silent> [unite]q :<C-u>Unite -no-quit -no-start-insert quickfix<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-quickrun') " {{{
  nmap <silent> <Leader>r <Plug>(quickrun)

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-ref') " {{{
  " マッピング {{{
  autocmd VimrcAutocmd FileType * if &filetype =~# '\v^ref-.+' | nnoremap <silent> <buffer> q :bdelete<CR> | endif
  " }}}

  let neobundle#hooks.on_source = s:fpath('vim-ref.vim')

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-watchdogs') " {{{
  if !exists('g:quickrun_config')
    let g:quickrun_config = {}
  endif
  if !has_key(g:quickrun_config, 'watchdogs_checker/_')
    let g:quickrun_config['watchdogs_checker/_'] = {}
  endif
  let g:quickrun_config['watchdogs_checker/_']['runner/vimproc/updatetime'] = 20
  let g:quickrun_config['watchdogs_checker/_']['outputter/quickfix/open_cmd'] = ''

  " tomlv
  if !has_key(g:quickrun_config, 'toml/watchdogs_checker')
    let g:quickrun_config['toml/watchdogs_checker'] = {}
  endif
  let g:quickrun_config['toml/watchdogs_checker']['type'] = executable('tomlv') ? 'watchdogs_checker/tomlv' : ''

  if !has_key(g:quickrun_config, 'watchdogs_checker/tomlv')
    let g:quickrun_config['watchdogs_checker/tomlv'] = {}
  endif
  let g:quickrun_config['watchdogs_checker/tomlv']['command'] = 'tomlv'
  let g:quickrun_config['watchdogs_checker/tomlv']['exec'] = '%c %s:p'
  let g:quickrun_config['watchdogs_checker/tomlv']['quickfix/errorformat'] = "Error in '%f': Near line %l %m"

  " 書き込み後にシンタックスチェックを行う
  let g:watchdogs_check_BufWritePost_enable = 1
  " Haskellのチェックは無効にする
  let g:watchdogs_check_BufWritePost_enables = {
        \ "haskell": 0,
        \ }

  " 一定時間以上キー入力がなかった場合にシンタックスチェックを行う
  " バッファに書き込み後、1度だけ行われる
  let g:watchdogs_check_CursorHold_enable = 1
  " Haskellのチェックは無効にする
  let g:watchdogs_check_CursorHold_enables = {
        \ "haskell": 0,
        \ }

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-qfsigns') " {{{
  let g:qfsigns#AutoJump = 1

  if !exists('g:quickrun_config')
    let g:quickrun_config = {}
  endif
  if !has_key(g:quickrun_config, 'watchdogs_checker/_')
    let g:quickrun_config['watchdogs_checker/_'] = {}
  endif
  let g:quickrun_config['watchdogs_checker/_']['hook/qfsigns_update/enable_exit'] = 1
  let g:quickrun_config['watchdogs_checker/_']['hook/qfsigns_update/priority_exit'] = 3

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-qfstatusline') " {{{
  " これだとステータスラインに何も出ないが、この変数設定は必須
  let g:Qfstatusline#UpdateCmd = function('qfstatusline#Update')

  if !exists('g:quickrun_config')
    let g:quickrun_config = {}
  endif
  if !has_key(g:quickrun_config, 'watchdogs_checker/_')
    let g:quickrun_config['watchdogs_checker/_'] = {}
  endif
  let g:quickrun_config['watchdogs_checker/_']['hook/qfstatusline_update/enable_exit'] = 1
  let g:quickrun_config['watchdogs_checker/_']['hook/qfstatusline_update/priority_exit'] = 3

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-easymotion') " {{{
  " 設定 {{{
  let g:EasyMotion_smartcase = 1
  let g:EasyMotion_enter_jump_first = 1
  let g:EasyMotion_space_jump_first = 1
  let g:EasyMotion_startofline = 0
  " }}}

  " マッピング {{{
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
  " }}}

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-anzu') " {{{
  " マッピング {{{
  nmap n <Plug>(anzu-n)zvzz
  nmap N <Plug>(anzu-N)zvzz
  nmap * <Plug>(anzu-star)zvzz
  nmap # <Plug>(anzu-sharp)zvzz
  " }}}

  " @vimlint(EVL103, 1, a:bundle)
  function! neobundle#hooks.on_source(bundle) abort " {{{
    autocmd VimrcAutocmd CursorHold,CursorHoldI,WinLeave,TabLeave * call anzu#clear_search_status()
  endfunction " }}}
  " @vimlint(EVL103, 0, a:bundle)

  call neobundle#untap()
endif " }}}

if neobundle#tap('restart.vim') " {{{
  command! -bar RestartWithSession let g:restart_sessionoptions = 'blank,buffers,curdir,folds,help,localoptions,tabpages' | Restart

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-operator-replace') " {{{
  " マッピング {{{
  map R <Plug>(operator-replace)
  xmap p <Plug>(operator-replace)
  " }}}

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-operator-surround') " {{{
  " マッピング {{{
  map <silent> ra <Plug>(operator-surround-append)
  map <silent> rd <Plug>(operator-surround-delete)
  map <silent> rc <Plug>(operator-surround-replace)
  " }}}

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-unified-diff') " {{{
  " @vimlint(EVL103, 1, a:bundle)
  function! neobundle#hooks.on_source(bundle) abort " {{{
    set diffexpr=unified_diff#diffexpr()
  endfunction " }}}
  " @vimlint(EVL103, 0, a:bundle)

  call neobundle#untap()
endif " }}}

if neobundle#tap('colorizer') " {{{
  let g:colorizer_nomap = 1

  call neobundle#untap()
endif " }}}

if neobundle#tap('ghcmod-vim') " {{{
  autocmd VimrcAutocmd FileType haskell nnoremap <buffer> <Leader>tt :GhcModType<CR>
  autocmd VimrcAutocmd FileType haskell nnoremap <buffer> <Leader>tc :GhcModTypeClear<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('matchit.zip') " {{{
  let neobundle#hooks.on_post_source = s:fpath('matchit.zip.vim')

  call neobundle#untap()
endif " }}}

if neobundle#tap('lightline.vim') " {{{
  " g:lightline {{{
  let g:lightline = {
        \   'separator': {
        \     'left': '⮀',
        \     'right': '⮂',
        \   },
        \   'subseparator': {
        \     'left': '⮁',
        \     'right': '⮃',
        \   },
        \   'active': {
        \     'left': [
        \       [ 'mode', 'eskk', ],
        \       [ 'filename', ],
        \       [ 'fugitive', 'gitinfo', ],
        \     ],
        \     'right': [
        \       [ 'syntaxcheck', 'lineinfo', ],
        \       [ 'fileformat', 'fileencoding', 'filetype', ],
        \       [ 'anzu', ],
        \     ],
        \   },
        \   'inactive': {
        \     'left': [
        \       [ 'inactivemode', ],
        \       [ 'filename', ],
        \       [ 'fugitive', 'gitinfo', ],
        \     ],
        \     'right': [
        \       [ 'syntaxcheck', 'lineinfo', ],
        \       [ 'fileformat', 'fileencoding', 'filetype', ],
        \       [ 'anzu', ],
        \     ],
        \   },
        \   'component': {
        \     'inactivemode': '%{"INACTIVE"}',
        \     'lineinfo': '⭡ %3l:%-2v (%p%%)',
        \     'fileformat': '%{FileInfoVisible() ? &fileformat : ""}',
        \     'filetype': '%{FileInfoVisible() ? (!empty(&filetype) ? &filetype : "no ft") : ""}',
        \     'fileencoding': '%{FileInfoVisible() ? (!empty(&fileencoding) ? &fileencoding : &encoding) : ""}',
        \     'anzu': '%{AnzuVisible() ? Anzu() : ""}',
        \   },
        \   'component_function': {
        \     'mode': 'Mode',
        \     'eskk': 'Eskk',
        \     'fugitive': 'Fugitive',
        \     'gitinfo': 'Gitinfo',
        \     'filename': 'Filename',
        \   },
        \   'component_expand': {
        \     'syntaxcheck': 'qfstatusline#Update',
        \   },
        \   'component_visible_condition': {
        \     'eskk': 'EskkVisible()',
        \     'fugitive': 'FugitiveVisible()',
        \     'fileformat': 'FileInfoVisible()',
        \     'filetype': 'FileInfoVisible()',
        \     'fileencoding': 'FileInfoVisible()',
        \     'gitinfo': 'GitinfoVisible()',
        \     'anzu': 'AnzuVisible()',
        \   },
        \   'component_type': {
        \     'syntaxcheck': 'error',
        \   },
        \ }
  " }}}

  " lightline functions {{{
  function! Mode() abort " {{{
    return &ft == 'unite' ? 'Unite' :
          \ &ft == 'vimfiler' ? 'VimFiler' :
          \ &ft == 'vimshell' ? 'VimShell' :
          \ winwidth(0) > 60 ? lightline#mode() : ''
  endfunction " }}}

  function! s:readonly() abort " {{{
    return &filetype !~? 'help\|vimfiler\|gundo' && &readonly ? '⭤' : ''
  endfunction " }}}

  function! s:modified() abort " {{{
    return &filetype =~# 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
  endfunction " }}}

  function! Filename() abort " {{{
    return (!empty(s:readonly()) ? s:readonly().' ' : '').
          \ (&filetype ==? 'vimfiler' ? vimfiler#get_status_string() :
          \  &filetype ==? 'unite' ? substitute(unite#get_status_string(), ' | ', '', '') :
          \  &filetype ==? 'vimshell' ? substitute(b:vimshell.current_dir, expand('~'), '~', '') :
          \  !empty(expand('%')) ? expand('%') : '[No Name]').
          \ (!empty(s:modified()) ? ' '.s:modified() : '')
  endfunction " }}}

  function! EskkVisible() abort " {{{
    return exists('*eskk#statusline') && !empty(eskk#statusline())
  endfunction " }}}

  function! Eskk() abort " {{{
    return EskkVisible() ? matchlist(eskk#statusline(), "^\\[eskk:\\(.\\+\\)\\]$")[1] : ''
  endfunction " }}}

  function! FugitiveVisible() abort " {{{
    return &ft != 'vimfiler' && exists('*fugitive#head') && !empty(fugitive#head())
  endfunction " }}}

  function! Fugitive() abort " {{{
    return FugitiveVisible() ? '⭠ '.fugitive#head() : ''
  endfunction " }}}

  function! GitinfoVisible() abort " {{{
    return exists('*GitGutterGetHunkSummary') && get(g:, 'gitgutter_enabled', 0) && winwidth(0) > 90
  endfunction " }}}

  function! Gitinfo() abort " {{{
    if !GitinfoVisible()
      return ''
    endif

    let symbols = [
          \ g:gitgutter_sign_added.' ',
          \ g:gitgutter_sign_modified.' ',
          \ g:gitgutter_sign_removed.' ',
          \ ]
    let hunks = GitGutterGetHunkSummary()
    let ret = []
    for i in [0, 1, 2]
      if hunks[i] > 0
        call add(ret, symbols[i].hunks[i])
      endif
    endfor

    return join(ret, ' ')
  endfunction " }}}

  function! FileInfoVisible() abort " {{{
    return &ft != 'unite' && &ft != 'vimfiler' && winwidth(0) > 70
  endfunction " }}}

  function! AnzuVisible() abort " {{{
    return exists('*anzu#search_status') && !empty(anzu#search_status()) && winwidth(0) > 70
  endfunction " }}}

  function! Anzu() abort " {{{
    return anzu#search_status()
  endfunction " }}}
  " }}}

  " リアルタイムにカラースキームを書き換えるための細工（helpからコピー）
  autocmd VimrcAutocmd ColorScheme * call <SID>lightline_update()
  function! s:lightline_update() " {{{
    try
      if g:colors_name =~# 'wombat\|solarized\|landscape\|jellybeans\|Tomorrow'
        let g:lightline.colorscheme =
              \ substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '') .
              \ (g:colors_name ==# 'solarized' ? '_' . &background : '')
      else
        let g:lightline.colorscheme = 'default'
      endif
      call lightline#init()
      call lightline#colorscheme()
      call lightline#update()
    catch
    endtry
  endfunction " }}}

  " @vimlint(EVL103, 1, a:bundle)
  function! neobundle#hooks.on_source(bundle) abort " {{{
    " qfstatusが入っているか否かに関わらず設定だけする
    let g:Qfstatusline#UpdateCmd = function('lightline#update')

    set noshowmode
  endfunction " }}}
  " @vimlint(EVL103, 0, a:bundle)

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-fugitive') " {{{
  " マッピング {{{
  " prefix定義
  nnoremap [git] <Nop>
  nmap <Leader>g [git]

  nnoremap <silent> [git]s :<C-u>Gstatus<CR>
  nnoremap <silent> [git]d :<C-u>Gvdiff<CR>
  " }}}

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-merginal') " {{{
  nnoremap <silent> [git]m :<C-u>Merginal<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('agit.vim') " {{{
  nnoremap <silent> [git]a :<C-u>Agit<CR>
  nnoremap <silent> [git]f :<C-u>AgitFile<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-gitgutter') " {{{
  let neobundle#hooks.on_source = s:fpath('vim-gitgutter.vim')

  call neobundle#untap()
endif " }}}

if neobundle#tap('neosnippet-additional') " {{{
  function! neobundle#hooks.on_source(bundle) abort " {{{
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

    let g:neosnippet#snippets_directory = join(add(dirs, snippets_dir), ',')
  endfunction " }}}

  call neobundle#untap()
endif " }}}

if neobundle#tap('unite-googletodo') " {{{
  " @vimlint(EVL103, 1, a:bundle)
  function! neobundle#hooks.on_source(bundle) abort " {{{
    let g:unite#googletodo#clear_on_complete = 1
  endfunction " }}}
  " @vimlint(EVL103, 0, a:bundle)

  nnoremap <silent> [unite]t :<C-u>Unite googletodo -no-start-insert<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('foldCC.vim') " {{{
  let g:foldCCtext_enable_autofdc_adjuster = 1

  call neobundle#untap()
endif " }}}

if neobundle#tap('unite-outline') " {{{
  nnoremap <silent> [unite]o :<C-u>Unite outline -no-start-insert -resume<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('junkfile.vim') " {{{
  nnoremap <silent> [unite]j :<C-u>Unite junkfile/new junkfile<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('winresizer') " {{{
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

  " @vimlint(EVL103, 1, a:bundle)
  function! neobundle#hooks.on_post_source(bundle) abort " {{{
    execute 'unmap' g:winresizer_start_key
    if has('gui_running')
      execute 'unmap' g:winresizer_gui_start_key
    endif
  endfunction " }}}
  " @vimlint(EVL103, 0, a:bundle)
endif " }}}

if neobundle#tap('vim-gista') " {{{
  let g:gista#github_user = 'yyotti'

  call neobundle#untap()
endif " }}}

" vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:
