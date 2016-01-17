scriptencoding utf-8
"-----------------------------------------------------------------------------
" Initialize:
"

" <Leader> は <Space> にする
let g:mapleader = '\<Space>'

if IsWindows()
  " Windowsの場合はファイルパスの\を/にする
  set shellslash
endif

let $CACHE = expand('~/.cache_nvim') " FIXME 動作確認が済んだら~/.cacheにする
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif

" autocmdをいったん全削除
augroup NvimAutocmd
  autocmd!
augroup END

" runtimepathの初期設定
if has('vim_starting')
  if IsWindows()
    let &runtimepath = join(
          \   [
          \     expand('~/.config/nvim'),
          \     expand('$VIM/runtile'),
          \     expand('~/.config/nvim/after'),
          \   ],
          \   ','
          \ )
  endif

  function! s:clone(name, dir) abort
    execute printf(
          \   '!git clone %s://github.com/Shougo/%s.git',
          \   exists('$http_proxy') ? 'https' : 'git',
          \   a:name
          \ ) a:dir
  endfunction

  " deinをロードする
  if &runtimepath !~ '/dein.vim'
    let s:dein_dir = expand('$CACHE/dein') . '/dein.vim'
    if !isdirectory(s:dein_dir)
      call s:clone('dein.vim', s:dein_dir)
    endif
    execute 'set runtimepath^=' . s:dein_dir
    unlet s:dein_dir
  endif

  " FIXME とりあえず dein だけでやるが、最終的に vimproc も有効にする
  if 0 && IsUnix()
    " Linuxならvimprocも用意する
    " TODO Linuxでなくても事前準備は可能なので改善の余地あり
    if &runtimepath !~ '/vimproc.vim'
      let s:vimproc_dir = expand('$CACHE/dein') . '/vimproc.vim'
      if !isdirectory(s:vimproc_dir)
        call s:clone('vimproc.vim', s:vimproc_dir)

        " Build
        execute printf('!cd "%s"; make', s:vimproc_dir)
      endif

      " runtimepathへの追加はdeinがやってくれる

      unlet s:vimproc_dir
    endif
  endif
endif

" TODO deinでもこれは必要か？
" let g:neobundle#default_options = {}

" デフォルトのプラグインを無効化する {{{

" TODO GUIでの動作確認
" if has('gui_running')
"   set guioptions=Mc
" endif

" TODO できるなら matchit を遅延ロードにしたい
let g:loaded_gzip = 1
let g:loaded_tarPlugin = 1
let g:loaded_zipPlugin = 1
let g:loaded_netrwPlugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_matchparen = 1
let g:loaded_rrhelper = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_logipat = 1
let g:loaded_logipat = 1
" }}}

" vim:set foldmethod=marker:
