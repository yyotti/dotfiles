scriptencoding utf-8
"-----------------------------------------------------------------------------
" Mappings:
"

" <C-Space>は<C-@>(<Nul>)にする
" これが何を意味するかはよく分かっていない
nmap <C-Space> <C-@>
cmap <C-Space> <C-@>

" Normal mode mappings: "{{{
" インデント
nnoremap > >>
nnoremap < <<

" 危険なマッピングを無効に
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" 表示行で移動
nnoremap j gj
nnoremap k gk

" 実際の行で移動
nnoremap gj j
nnoremap gk k

" アスタリスクでの検索時に、最初に次の位置へ移動してしまうのを改善
nnoremap * *<C-o>zvzz
nnoremap g* g*<C-o>zvzz
nnoremap # #<C-o>zvzz
nnoremap g# g#<C-o>zvzz

" ハイライトを消す
nnoremap <silent> <C-h> :<C-u>nohlsearch<CR>
"}}}

" Insert mode mappings: "{{{
" <C-t>はタブ
inoremap <C-t> <C-v><TAB>
" <C-d>は<DEL>
inoremap <C-d> <DEL>
" <C-a>は先頭に移動
inoremap <C-a> <C-o>^
" <C-e>は末尾に移動
inoremap <C-e> <C-o>$
" <C-w>と<C-u>でundoを可能にする
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

if has('gui_running')
  " <Esc>の反応をよくする？
  inoremap <ESC> <ESC>
endif
"}}}

" Visual mode mappings: "{{{
" <TAB>はインデント
xnoremap <TAB> >
" <S-TAB>はアンインデント
xnoremap <S-TAB> <

" インデント
xnoremap > >gv
xnoremap < <gv

" 表示行で移動
xnoremap j gj
xnoremap k gk

" 実際の行で移動
xnoremap gj j
xnoremap gk k

if has('clipboard')
  xnoremap <silent> y "*y:let [@+,@"]=[@*,@*]<CR>
endif
"}}}

" Command-line mode mappings: "{{{
" <C-a>:先頭
cnoremap <C-a> <Home>
" <C-e>:末尾
cnoremap <C-e> <End>
" <C-b>:左
cnoremap <C-b> <Left>
" <C-f>:右
cnoremap <C-f> <Right>
" <C-d>:1文字削除
cnoremap <C-d> <DEL>
" <C-p>:ヒストリバック
cnoremap <C-p> <Up>
" <C-n>:ヒストリフォワード
cnoremap <C-n> <Down>
" <C-y>:ペースト
cnoremap <C-y> <C-r>*
" <C-g>:Exit
cnoremap <C-g> <C-c>

" <C-o>:検索時のみ、単語境界をトグル
cnoremap <C-o> <C-\>e<SID>toggle_word_border()<CR>
function! s:toggle_word_border() abort "{{{
  let l:cmdline = getcmdline()
  if getcmdtype() !=# '/' && getcmdtype() !=# '?'
    return l:cmdline
  endif

  if l:cmdline !~# '^\\<.*\\>$'
    let l:cmdline = '\<' . l:cmdline . '\>'
  else
    let l:cmdline = l:cmdline[2:len(l:cmdline) - 3]
  endif

  return l:cmdline
endfunction "}}}
"}}}

" a>やi>を置き換える "{{{
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
"}}}

" 設定ファイル操作 "{{{
" vimrc
nnoremap <silent> <Leader>;v
      \ :<C-u>edit <C-r>=resolve(expand($MYVIMRC))<CR><CR>
" reload vimrc
nnoremap <silent> <Leader>;r
      \ :<C-u>source $MYVIMRC<CR> \| :echo "source " . $MYVIMRC<CR>

" .tmux.conf
if filereadable(expand('~/.tmux.conf'))
  nnoremap <silent> <Leader>;t
        \ :<C-u>edit <C-r>=resolve(expand('~/.tmux.conf'))<CR><CR>
endif

" .zshrc
if filereadable(expand('~/.zshrc'))
  nnoremap <silent> <Leader>;z
        \ :<C-u>edit <C-r>=resolve(expand('~/.zshrc'))<CR><CR>
endif
"}}}

" ウィンドウ移動 "{{{
nnoremap <Leader>h <C-w>h
nnoremap <Leader>l <C-w>l
nnoremap <Leader>k <C-w>k
nnoremap <Leader>j <C-w>j

nnoremap <Leader>x <C-w>x

nnoremap <Leader>H <C-w>H
nnoremap <Leader>L <C-w>L
nnoremap <Leader>K <C-w>K
nnoremap <Leader>J <C-w>J
"}}}

" バッファ操作 "{{{
nnoremap <silent> <Leader>o :<C-u>only<CR>
nnoremap <silent> <Leader>d :<C-u>bdelete<CR>
nnoremap <silent> <Leader>D :<C-u>bdelete!<CR>
"}}}

" Others "{{{
" backgroundの切り替え
nmap <expr> <C-b> <SID>toggle_background()
function! s:toggle_background() abort "{{{
  if &background ==# 'light'
    set background=dark
  else
    set background=light
  endif
endfunction "}}}

" xを捨て
nnoremap x "_x

" Exモードは無効
nnoremap Q q

" terminalでの<Esc>は<C-\><C-n>にする
tnoremap <Esc> <C-\><C-n>
"}}}

" vim:set foldmethod=marker:
