scriptencoding utf-8
"-----------------------------------------------------------------------------
" View:
"
" Anywhere SID
function! s:SID_PREFIX() abort "{{{
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction "}}}

set number
set list
if IsWindows()
  set listchars=tab:>-,extends:<,trail:-
else
  set listchars=tab:»\ ,extends:<,trail:-
endif

set cmdheight=2

set showcmd

set title

set titlelen=95
" タイトル文字列(tmuxを使っていないときに関係してくる)
let &g:titlestring = "%{expand('%:p:~:.')}%(%m%r%w%)"
      \ . '%<\(%{'.s:SID_PREFIX().'strwidthpart('
      \ . "fnamemodify(&filetype ==# 'vimfiler' ?"
      \ . "substitute(b:vimfiler.current_dir, '.\\zs/$', '', '') : getcwd(), ':~'),"
      \ . "&columns-len(expand('%:p:.:~')))}\) - NVIM""
function! s:strwidthpart(str, width) abort "{{{
  if a:width <= 0
    return ''
  endif

  let l:ret = a:str
  let l:width = strwidth(a:str)
  while l:width > a:width
    let l:char = matchstr(l:ret, '.$')
    let l:ret = l:ret[: -1 - len(l:char)]
    let l:width -= strwidth(l:char)
  endwhile

  return l:ret
endfunction "}}}

" ステータスライン
if !IsPowerlineEnabled()
  " Powerlineもlightline.vimもOFFの場合はこの設定とする
  " lightline.vimが有効であれば後で上書きされる
  let &g:statusline = "%{winnr('$')>1?'['.winnr().'/'.winnr('$')"
        \ . ".(winnr('#')==winnr()?'#':'').']':''}\ "
        \ . "%{(&previewwindow?'[preview] ':'').expand('%:t')}"
        \ . "%{exists('*anzu#search_status')&&!empty(anzu#search_status())?"
        \ . "anzu#search_status():''}"
        \ . "\ %=%{(winnr('$')==1 || winnr('#')!=winnr()) ?"
        \ . "'['.(&filetype!=''?&filetype.',':'')"
        \ . ".(&fenc!=''?&fenc:&enc).','.&ff.']' : ''}"
        \ . "%m%{printf('%'.(len(line('$'))+2).'d/%d',line('.'),line('$'))}"
        \ . "%{exists('*qfstatusline#Update')?qfstatusline#Update():''}"
endif

" 折り返し
set linebreak
set showbreak=\
set breakat=\ \	;:,!?
set whichwrap+=h,l,<,>,[,],b,s,~
set breakindent

set cursorline

set shortmess=aTI

set completeopt=menuone
" 他のバッファから補完しない
set complete=.
" 補完時の一覧の高さ
set pumheight=20

" 変更された行数を必ず報告する
set report=0

" <C-d>や<C-f>などで移動した場合にカーソル位置を可能な限り同じ列におく
set nostartofline

" コマンドウィンドウの最大行数
set cmdwinheight=5
" 分割時にウィンドウサイズを等しくしない
set noequalalways

" ヘルプウィンドウの最小の高さ
set helpheight=12

set conceallevel=2
set concealcursor=niv

set colorcolumn=79

" カーソルが変に飛んでしまうのでマウスは無効とする
set mouse-=a

" vim:set foldmethod=marker:
