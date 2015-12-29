scriptencoding utf-8
"--------------------------------------------------------------------------------
" Mappings:
"

" <C-Space>は<C-@>(<Nul>)にする
" これが何を意味するかはよく分かっていない
nmap <C-Space> <C-@>
cmap <C-Space> <C-@>

" ノーマルモードのマッピング {{{
" インデント
nnoremap > >>
nnoremap < <<

" 危険なキーマッピングを無効に
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" 表示行で移動
nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk

" 実際の行で移動
nnoremap gj j
nnoremap gk k
xnoremap gj j
xnoremap gk k

" 行末までコピー（Dで行末まで削除できるのに合わせる）
nnoremap Y y$

" アスタリスクでの検索時に、最初に次の位置へ移動してしまうのを改善
nnoremap * *<C-o>zvzz
nnoremap g* g*<C-o>zvzz
nnoremap # #<C-o>zvzz
nnoremap g# g#<C-o>zvzz

" ハイライトを消す
nnoremap <silent> <C-h> :<C-u>nohlsearch<CR>
" }}}

" インサートモードのマッピング {{{
" <C-t>はタブを入力
inoremap <C-t> <C-v><TAB>
" <C-d>は<DEL>
inoremap <C-d> <DEL>
" <C-a>は先頭に移動
inoremap <C-a> <C-o>^
" <C-w>と<C-u>でundoを可能にする
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

if has('gui_running')
  " <Esc>の反応をよくする？
  inoremap <ESC> <ESC>
endif
" }}}

" ビジュアルモードのマッピング {{{
" <TAB>はインデントにする
xnoremap <TAB> >
" <S-TAB>はアンインデント
xnoremap <S-TAB> <

" インデント
xnoremap > >gv
xnoremap < <gv

if has('clipboard')
  xnoremap <silent> y "*y:let [@+,@"]=[@*,@*]<CR>
endif
" }}}

" コマンドラインモードのマッピング {{{
" <C-a>で先頭へ
cnoremap <C-a> <Home>
" <C-e>で末尾へ
cnoremap <C-e> <End>
" <C-b>で1文字戻る
cnoremap <C-b> <Left>
" <C-f>で1文字進む
cnoremap <C-f> <Right>
" <C-d>は<DEL>
cnoremap <C-d> <Del>
" <C-p>は<Up>
cnoremap <C-p> <Up>
" <C-n>は<Down>
cnoremap <C-n> <Down>
" <C-y>でペースト
cnoremap <C-y> <C-r>*

" C-oで単語境界をトグルする(検索時のみ)
cnoremap <C-o> <C-\>e<SID>toggle_word_border()<CR>
function! s:toggle_word_border() abort
  let cmdline = getcmdline()
  if getcmdtype() != '/' && getcmdtype() != '?'
    return cmdline
  endif

  if cmdline !~# '^\\<.*\\>$'
    let cmdline = '\<' . cmdline . '\>'
  else
    let cmdline = cmdline[2:len(cmdline) - 3]
  endif

  return cmdline
endfunction

" }}}

" a>やi>を置き換える {{{
" <angle>
onoremap aa a>
xnoremap aa a>
onoremap ia i>
xnoremap ia i>

" [rectangle]
onoremap ar a]
xnoremap ar a]
onoremap ir i]
xnoremap ir i]

" 'quote'
onoremap as a'
xnoremap as a'
onoremap is i'
xnoremap is i'

" "double quote"
onoremap ad a"
xnoremap ad a"
onoremap id i"
xnoremap id i"
" }}}

" 設定ファイル操作 {{{
" vimrcを開く
nnoremap <silent> <Leader>;v :<C-u>edit <C-r>=resolve(expand($MYVIMRC))<CR><CR>
" vimrcをリロード
nnoremap <silent> <Leader>;r :<C-u>source $MYVIMRC<CR>

if filereadable(expand('~/.tmux.conf'))
  " tmux.confを開く
  nnoremap <silent> <Leader>;t :<C-u>edit <C-r>=resolve(expand('~/.tmux.conf'))<CR><CR>
endif
if filereadable(expand('~/.zshrc'))
  " zshrcを開く
  nnoremap <silent> <Leader>;z :<C-u>edit <C-r>=resolve(expand('~/.zshrc'))<CR><CR>
endif
" }}}

" ウィンドウ移動 {{{
nnoremap <Leader>h <C-w>h
nnoremap <Leader>l <C-w>l
nnoremap <Leader>k <C-w>k
nnoremap <Leader>j <C-w>j

" ウィンドウを入れ替える
nnoremap <Leader>x <C-w>x

" ウィンドウの位置を組替える
nnoremap <Leader>K <C-w>K
nnoremap <Leader>J <C-w>J
nnoremap <Leader>H <C-w>H
nnoremap <Leader>L <C-w>L
" }}}

" バッファ操作 {{{
" バッファのみにする
nnoremap <silent> <Leader>o :<C-u>only<CR>
" バッファ削除(ウィンドウを残す)
nnoremap <silent> <Leader>d :<C-u>call <SID>delete_buffer(0)<CR>
" バッファ削除(ノーマル)
nnoremap <silent> <Leader>D :<C-u>bdelete<CR>

function! s:delete_buffer(force) abort " {{{
  let current = bufnr('%')

  call s:alternate_buffer()

  if a:force
    silent! execute 'bdelete! ' . current
  else
    silent! execute 'bdelete ' . current
  endif
endfunction " }}}

function! s:alternate_buffer() abort " {{{
  let listed_buffer_len = len(filter(range(1, bufnr('$')), 's:buflisted(v:val) && getbufvar(v:val, "&filetype") !=# "unite"'))
  if listed_buffer_len <= 1
    enew
    return
  endif

  let cnt = 0
  let pos = 1
  let current = 0
  while pos <= bufnr('$')
    if s:buflisted(pos)
      if pos == bufnr('%')
        let current = cnt
      endif

      let cnt += 1
    endif

    let pos += 1
  endwhile

  if current > cnt / 2
    bprevious
  else
    bnext
  endif
endfunction " }}}

function! s:buflisted(bufnr) abort " {{{
  return exists('t:unite_buffer_directory') ? has_key(t:unite_buffer_directory, a:bufnr) && buflisted(a:bufnr) : buflisted(a:bufnr)
endfunction " }}}
" }}}

" diff {{{
" TODO Diffモードのときのみ有効にしたい
nnoremap <silent> <Leader>ig :<C-u>diffget<CR>
nnoremap <silent> <Leader>ip :<C-u>diffput<CR>
nnoremap <silent> <Leader>iu :<C-u>diffupdate<CR>
" }}}

" その他 {{{
" backgroundの light/dark を切り替える
nmap <expr> <C-b> <SID>toggle_background()
function! s:toggle_background() abort
  if &background ==# 'light'
    set background=dark
  else
    set background=light
  endif
endfunction

" xをヤンク目的では使用しないので、捨てる(ノーマルモードのみ)
nnoremap x "_x

" Exモードを無効にする
nnoremap Q q
" }}}

" vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:
