scriptencoding utf-8
"-----------------------------------------------------------------------------
" Initialize:
"

" <Leader> は <Space> にする
let g:mapleader = "\<Space>"

if IsWindows()
  " Windowsの場合はファイルパスの\を/にする
  set shellslash
endif

let $CACHE = expand('~/.cache')
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif

" autocmdをいったん全削除
augroup NvimAutocmd
  autocmd!
augroup END

" runtimepathの初期設定
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

function! s:clone(name, dir) abort "{{{
  execute printf('!git clone https://github.com/Shougo/%s', a:name) a:dir
endfunction "}}}

" deinをロードする
if &runtimepath !~# '/dein.vim'
  let s:dein_dir = expand('$CACHE/dein') .
        \ '/repos/github.com/Shougo/dein.vim'
  if !isdirectory(s:dein_dir)
    call s:clone('dein.vim', s:dein_dir)
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_dir, ':p')
  unlet s:dein_dir
endif

if IsUnix()
  " Linuxならvimprocも用意する
  " TODO Linuxでなくても事前準備は可能なので改善の余地あり
  if &runtimepath !~# '/vimproc.vim'
    let s:vimproc_dir = expand('$CACHE/dein') .
          \ '/repos/github.com/Shougo/vimproc.vim'
    if !isdirectory(s:vimproc_dir)
      call s:clone('vimproc.vim', s:vimproc_dir)

      " Build
      execute printf('!cd "%s"; make', s:vimproc_dir)
    endif

    " runtimepathへの追加はdeinがやってくれる

    unlet s:vimproc_dir
  endif
endif

" デフォルトのプラグインを無効化する {{{

" TODO GUIでの動作確認
" if has('gui_running')
"   set guioptions=Mc
" endif

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

" matchitはここでいったんロード済みにして、後でロードできるようにする
let g:loaded_matchit = 1
" }}}

" vim:set foldmethod=marker:
