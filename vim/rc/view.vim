scriptencoding utf-8
"--------------------------------------------------------------------------------
" View:
"

" Anywhere SID
function! s:SID_PREFIX() abort " {{{
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction " }}}

" INSERTモード時などに --INSERT-- などを表示させる
" lightline.vimがインストールされているかPowerlineが有効な場合はOFFにされる
set showmode

" 行番号を表示
set number
if v:version >= 703
  " 相対行数を表示
  set relativenumber
endif

" タブや改行を表示する
set list
if IsWindows()
  " TODO Windowsの場合の表示は要確認
  set listchars=tab:>-,extends:<,trail:-
else
  set listchars=tab:»\ ,extends:<,trail:-
endif

" ステータスラインは常に表示する
set laststatus=2
" コマンドラインの高さ
set cmdheight=2
" コマンドを表示する
set showcmd
" タイトルを表示する
set title
" タイトルの長さ
set titlelen=95
" タイトル文字列(tmuxを使っていないときに関係してくる)
let &g:titlestring="%{expand('%:p:~:.')}%(%m%r%w%)%<\(%{".s:SID_PREFIX()."strwidthpart(fnamemodify(&filetype ==# 'vimfiler' ? substitute(b:vimfiler.current_dir, '.\\zs/$', '', '') : getcwd(), ':~'),&columns-len(expand('%:p:.:~')))}\) - VIM"
" タブがあればタブラインを表示する
set showtabline=1

" ステータスライン
if !PowerlineEnabled()
  " Powerlineもlightline.vimもOFFの場合はこの設定とする
  " lightline.vimが有効であれば後で上書きされる
  let &g:statusline = "%{winnr('$')>1?'['.winnr().'/'.winnr('$')"
        \ . ".(winnr('#')==winnr()?'#':'').']':''}\ "
        \ . "%{(&previewwindow?'[preview] ':'').expand('%:t')}"
        \ . "%{exists('*anzu#search_status')&&!empty(anzu#search_status())?anzu#search_status():''}"
        \ . "\ %=%{(winnr('$')==1 || winnr('#')!=winnr()) ?
        \ '['.(&filetype!=''?&filetype.',':'')"
        \ . ".(&fenc!=''?&fenc:&enc).','.&ff.']' : ''}"
        \ . "%m%{printf('%'.(len(line('$'))+2).'d/%d',line('.'),line('$'))}"
        \ . "%{exists('*qfstatusline#Update')?qfstatusline#Update():''}"
endif

" 長い行も折り返さない
set nowrap

" カーソル行をハイライトする
set cursorline

" Vim起動時のメッセージを表示しない
set shortmess=aTI

" ベルを抑止
set t_vb=
set novisualbell

" コマンド候補はステータスバーに表示する
set wildmenu
set wildmode=longest,full
" 履歴を増やす
set history=1000

" 補完設定(よく分かっていない)
set completeopt=menuone
" 他のバッファから補完しない
set complete=.
" 補完時の一覧の高さ
set pumheight=20

" 変更された行数を必ず報告する
set report=0

" <C-d>や<C-f>などで移動した場合にカーソル位置を可能な限り同じ列におく
set nostartofline

" カレント以外のウィンドウの最小幅
set winwidth=20
" カレント以外のウィンドウの最小高
set winheight=1
" コマンドウィンドウの最大行数
set cmdwinheight=5
" 分割時にウィンドウサイズを等しくしない
set noequalalways

" ヘルプウィンドウの最小の高さ
set helpheight=12

set ttyfast

" すごく長い行も@にせず表示する
set display=lastline

function! s:strwidthpart(str, width) abort " {{{
  if a:width <= 0
    return ''
  endif

  let ret = a:str
  let width = s:wcswidth(a:str)
  while width > a:width
    let char = matchstr(ret, '.$')
    let ret = ret[: -1 - len(char)]
    let width -= s:wcswidth(char)
  endwhile

  return ret
endfunction " }}}

if v:version >= 703
  set conceallevel=2

  function! s:wcswidth(str) abort " {{{
    return strwidth(a:str)
  endfunction " }}}

  finish
endif

function! s:wcswidth(str) abort " {{{
  if a:str =~# '^[\x00-\x7f]*$'
    return strlen(a:str)
  end

  let mx_first = '^\(.\)'
  let str = a:str
  let width = 0
  while 1
    let ucs = char2nr(substitute(str, mx_first, '\1', ''))
    if ucs == 0
      break
    endif
    let width += s:_wcwidth(ucs)
    let str = substitute(str, mx_first, '', '')
  endwhile

  return width
endfunction " }}}

" UTF-8 only.
function! s:_wcwidth(ucs) abort " {{{
  let ucs = a:ucs
  if (ucs >= 0x1100
        \  && (ucs <= 0x115f
        \  || ucs == 0x2329
        \  || ucs == 0x232a
        \  || (ucs >= 0x2e80 && ucs <= 0xa4cf
        \      && ucs != 0x303f)
        \  || (ucs >= 0xac00 && ucs <= 0xd7a3)
        \  || (ucs >= 0xf900 && ucs <= 0xfaff)
        \  || (ucs >= 0xfe30 && ucs <= 0xfe6f)
        \  || (ucs >= 0xff00 && ucs <= 0xff60)
        \  || (ucs >= 0xffe0 && ucs <= 0xffe6)
        \  || (ucs >= 0x20000 && ucs <= 0x2fffd)
        \  || (ucs >= 0x30000 && ucs <= 0x3fffd)
        \  ))
    return 2
  endif

  return 1
endfunction " }}}

" vim:set sw=2 foldmethod=marker:
