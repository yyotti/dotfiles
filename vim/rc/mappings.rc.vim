"-----------------------------------------------------------------------------
" Mappings:
"
nmap <C-Space> <C-@>
cmap <C-Space> <C-@>

" Normal/Visual mode mappings: "{{{
nmap <Space> [Space]
nmap S [Alt]

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

nnoremap n nzz
nnoremap N Nzz
nnoremap * *<C-o>zvzz
nnoremap g* g*<C-o>zvzz
nnoremap # #<C-o>zvzz
nnoremap g# g#<C-o>zvzz

if !has('nvim') && has('clipboard')
  xnoremap <silent> y "*y:let [@+,@"]=[@*,@*]<CR>
endif

nnoremap x "_x
xnoremap x "_x

nnoremap [Space]w :<C-u>call vimrc#toggle_option('wrap')<CR>
nnoremap [Space]n :<C-u>call vimrc#toggle_option('number')<CR>

" Clear hlsearch
nnoremap [Space]h :<C-u>nohlsearch<CR>

" Smart <C-f>/<C-b>
nnoremap <expr> <C-f>
     \ max([winheight(0) - 2, 1]) . "\<C-d>" .
     \   (line('w$') >= line('$') ? 'L' : 'M')
nnoremap <expr> <C-b>
     \ max([winheight(0) - 2, 1]) . "\<C-u>" .
     \   (line('w0') <= 1 ? 'H' : 'M')

" Smart <C-d>/<C-u>
nnoremap <expr> <C-d>
     \ "\<C-d>" . (line('w$') >= line('$') ? 'L' : 'M')
nnoremap <expr> <C-u>
     \ "\<C-u>" . (line('w0') <= 1 ? 'H' : 'M')

nmap Y y$

" Folding
nnoremap zj zjzx
nnoremap zk zkzx

" Swap 0/^
nnoremap 0 ^
nnoremap ^ 0

" Vertical gf
function! OpenGF(direction) abort "{{{
  if winnr('$') > 1
    let l:winnr = winnr()
    execute 'wincmd' a:direction
    let l:winnr2 = winnr()

    if l:winnr !=# l:winnr2
      wincmd p
      execute l:winnr2 . 'hide'
    endif
  endif

  try
    let l:vertical = ''
    if a:direction ==# 'h' || a:direction ==# 'l'
      let g:save_splitright = &splitright
      let &splitright = a:direction ==# 'l'
      let l:vertical = 'vertical'
    else
      let g:save_splitbelow = &splitbelow
      let &splitbelow = a:direction ==# 'j'
    endif
    execute l:vertical 'wincmd F'
  finally
    if exists('g:save_splitright')
      let &splitright = g:save_splitright
      unlet g:save_splitright
    endif
    if exists('g:save_splitbelow')
      let &splitbelow = g:save_splitbelow
      unlet g:save_splitbelow
    endif
  endtry
endfunction "}}}

nnoremap gf gF
nnoremap <silent> gh :<C-u>call OpenGF('h')<CR>
nnoremap <silent> gl :<C-u>call OpenGF('l')<CR>
nnoremap <silent> gj :<C-u>call OpenGF('j')<CR>
nnoremap <silent> gk :<C-u>call OpenGF('k')<CR>

nnoremap [Alt] <Nop>

" Indent paste
nnoremap <silent> [Alt]p pm``[=`]``^
nnoremap <silent> [Alt]P Pm``[=`]``^

" Visual yank
xnoremap <silent> y y`]0

" If press l on fold, fold open.
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0' : 'l'
" If press l on fold, range fold open.
xnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'

"}}}

" Insert mode mappings: "{{{
inoremap <C-t> <C-v><TAB>

" Enable undo <C-w> and <C-u>
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

" Move cursor
inoremap <C-f> <C-g>U<Right>
inoremap <C-b> <C-g>U<Left>
inoremap <C-g>j <C-g>U<C-g>j
inoremap <C-g>k <C-g>U<C-g>k
inoremap <C-a> <C-g>U<Home>
inoremap <C-e> <C-g>U<End>
inoremap <Right> <C-g>U<Right>
inoremap <Left> <C-g>U<Left>
inoremap <Down> <C-g>U<Down>
inoremap <Up> <C-g>U<Up>
inoremap <Home> <C-g>U<Home>
inoremap <End> <C-g>U<End>

" Delete
inoremap <C-d> <DEL>

" Input same chars
inoremap <C-e> <C-y>
inoremap <C-z> <C-e>

" Toggle paste
inoremap <C-\> <C-o>:call vimrc#toggle_option('paste')<CR>

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
cnoremap <C-o> <C-\>e vimrc#toggle_cmdline_word_boundary()<CR>
" Smart <C-u>
cnoremap <C-u> <C-\>e vimrc#smart_ctrl_u()<CR>

" Insert current buffer name
cnoremap <C-x> <C-r>=expand('%')<CR>
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
nnoremap  [Space]   <Nop>

" reload vimrc
nnoremap <silent> [Space];r
      \ :<C-u>source $MYVIMRC<CR> \| :echo "source " . $MYVIMRC<CR>
"}}}

" Move cursor between windows "{{{
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j

nnoremap [Space]x <C-w>x
nnoremap [Space]= <C-w>=

nnoremap [Space]H <C-w>H
nnoremap [Space]L <C-w>L
nnoremap [Space]K <C-w>K
nnoremap [Space]J <C-w>J
"}}}

" Operate buffer "{{{
nnoremap <silent> [Space]o :<C-u>only<CR>
nnoremap <silent> [Space]O :<C-u>hide<CR>
nnoremap <silent> [Space]d :<C-u>call vimrc#smart_bdelete(0)<CR>
nnoremap <silent> [Space]D :<C-u>call vimrc#smart_bdelete(1)<CR>

nnoremap <silent> [Space]- :<C-u>new<CR>
nnoremap <silent> [Space]<Bar> :<C-u>vnew<CR>
"}}}

" Marks "{{{
let g:marker_chars = [
      \   'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
      \   'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
      \ ]

autocmd MyAutocmd BufEnter * if !exists('b:marker_idx') | delmarks! | endif

" Disable buffer local marks
for s:c in g:marker_chars
  execute printf('nnoremap <silent> m%s <NOP>', s:c)
  unlet s:c
endfor
nnoremap <silent> mm :<C-u>call vimrc#automark()<CR>
"}}}
