"-----------------------------------------------------------------------------
" Mappings:
"
nmap <C-Space> <C-@>
cmap <C-Space> <C-@>

function! ToggleOption(option_name) abort "{{{
  execute 'setlocal' a:option_name.'!'
  execute 'setlocal' a:option_name.'?'
endfunction "}}}

" Normal/Visual mode mappings: "{{{
nnoremap > >>
nnoremap < <<
xnoremap > >gv
xnoremap < <gv

" Disable dangerous mappings
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" Disable Ex mode
nnoremap Q <Nop>

nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk

nnoremap gj j
nnoremap gk k
xnoremap gj j
xnoremap gk k

nnoremap n nzz
nnoremap N Nzz
nnoremap * *<C-o>zvzz
nnoremap g* g*<C-o>zvzz
nnoremap # #<C-o>zvzz
nnoremap g# g#<C-o>zvzz

if (!has('nvim') || $DISPLAY !=# '') && has('clipboard')
  xnoremap <silent> y "*y:let [@+,@"]=[@*,@*]<CR>
endif

nnoremap x "_x

nnoremap <Space>w :<C-u>call ToggleOption('wrap')<CR>
nnoremap <Space>N :<C-u>call ToggleOption('number')<CR>

" Clear hlsearch
nnoremap <silent> H :<C-u>nohlsearch<CR>

nnoremap <silent> U viwU
nnoremap <silent> gU viwu

" Smart <C-f>/<C-b>
nnoremap <expr> <C-f>
      \ max([winheight(0) - 2, 1]) . "\<C-d>" .
      \   (line('.') > line('$') - winheight(0) ? 'L' : 'H')
nnoremap <expr> <C-b>
      \ max([winheight(0) - 2, 1]) . "\<C-u>" .
      \   (line('.') < 1 + winheight(0) ? 'H' : 'L')

nnoremap Y y$

" Folding
nnoremap zj zjzx
nnoremap zk zkzx

" Swap 0/^
nnoremap 0 ^
nnoremap ^ 0
"}}}

" Insert mode mappings: "{{{
inoremap <C-t> <C-v><TAB>

" Enable undo <C-w> and <C-u>
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

" Move cursor
inoremap <C-f> <C-g>U<Right>
inoremap <C-b> <C-g>U<Left>

" Delete
inoremap <C-d> <DEL>

" Toggle paste
inoremap <C-\> <C-o>:call ToggleOption('paste')<CR>

if has('gui_running')
  inoremap <ESC> <ESC>
endif
"}}}

" Command-line mode mappings: "{{{
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <DEL>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

cnoremap <C-k>
      \ <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos() - 2]<CR>
cnoremap <C-t> <C-r>*
cnoremap <C-g> <C-c>

" Toggle word boundary
cnoremap <C-o> <C-\>e<SID>toggle_word_boundary()<CR>
function! s:toggle_word_boundary() abort "{{{
  let cmdline = getcmdline()
  if getcmdtype() !=# '/' && getcmdtype() !=# '?'
    return cmdline
  endif

  if cmdline !~# '^\\<.*\\>$'
    let cmdline = '\<' . cmdline . '\>'
  else
    let cmdline = cmdline[2:len(cmdline) - 3]
  endif

  return cmdline
endfunction "}}}
"}}}

" Replace a>,i>,etc... "{{{
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

" Edit config files "{{{
" reload vimrc
nnoremap <silent> <Space>;r
      \ :<C-u>source $MYVIMRC<CR> \| :echo "source " . $MYVIMRC<CR>
"}}}

" Move cursor between windows "{{{
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j

nnoremap <Space>x <C-w>x
nnoremap <Space>= <C-w>=

nnoremap <Space>H <C-w>H
nnoremap <Space>L <C-w>L
nnoremap <Space>K <C-w>K
nnoremap <Space>J <C-w>J
"}}}

" Location "{{{
nnoremap [E :<C-u>lfirst<CR>
nnoremap [e :<C-u>lprevious<CR>
nnoremap ]E :<C-u>llast<CR>
nnoremap ]e :<C-u>lnext<CR>
"}}}

" Operate buffer "{{{
nnoremap <silent> <Space>o :<C-u>only<CR>
nnoremap <silent> <Space>h :<C-u>hide<CR>
nnoremap <silent> <Space>d :<C-u>bdelete<CR>
nnoremap <silent> <Space>D :<C-u>bdelete!<CR>
"}}}
