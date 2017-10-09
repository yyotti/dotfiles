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

" Smart <C-f>/<C-b>
nnoremap <expr> <C-f>
      \ max([winheight(0) - 2, 1]) . "\<C-d>" .
      \   (line('.') > line('$') - winheight(0) ? 'L' : 'H')
nnoremap <expr> <C-b>
      \ max([winheight(0) - 2, 1]) . "\<C-u>" .
      \   (line('.') < 1 + winheight(0) ? 'H' : 'L')

if !hasmapto('Y', 'n')
  nnoremap Y y$
endif

" Folding
nnoremap zj zjzx
nnoremap zk zkzx

" Swap 0/^
nnoremap 0 ^
nnoremap ^ 0

" Vertical gf
function! OpenGF(direction) abort "{{{
  if winnr('$') > 1
    let winnr = winnr()
    execute 'wincmd' a:direction
    let winnr2 = winnr()

    if winnr !=# winnr2
      wincmd p
      execute winnr2 . 'hide'
    endif
  endif

  try
    let vertical = ''
    if a:direction ==# 'h' || a:direction ==# 'l'
      let g:save_splitright = &splitright
      let &splitright = a:direction ==# 'l'
      let vertical = 'vertical'
    else
      let g:save_splitbelow = &splitbelow
      let &splitbelow = a:direction ==# 'j'
    endif
    execute vertical 'wincmd F'
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
"}}}

" Insert mode mappings: "{{{
inoremap <C-t> <C-v><TAB>

" Enable undo <C-w> and <C-u>
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

" Move cursor
inoremap <C-f> <C-g>U<Right>
inoremap <C-b> <C-g>U<Left>
inoremap <C-a> <C-g>U<Home>
inoremap <C-e> <C-g>U<End>

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

" Operate buffer "{{{
function! SmartBDelete(force) abort "{{{
  let cur_bufnr = bufnr('%')

  let buffers = {}
  for buf in split(execute('ls'), "\n")
    let [ _, bufnr, bufstatus; _] =
          \ matchlist(buf, '^\s*\(\d\+\)\s*\([+-=auhx%#]\+\)')
    let buffers[bufnr] = bufstatus
  endfor

  if len(buffers) > winnr('$') && has_key(buffers, cur_bufnr)
    let alt_bufnr = bufnr('#')
    if !has_key(buffers, alt_bufnr) || buffers[alt_bufnr] =~# 'a'
      " Alt buffer is active buffer or not listed
      let next_bufnr =
            \ keys(filter(copy(buffers), { _, val -> val !~# 'a' }))[0]
    else
      let next_bufnr = alt_bufnr
    endif

    execute 'buffer' next_bufnr
  endif

  execute 'bdelete' . (a:force ? '!' : '') cur_bufnr
endfunction "}}}

nnoremap <silent> <Space>o :<C-u>only<CR>
nnoremap <silent> <Space>h :<C-u>hide<CR>
nnoremap <silent> <Space>d :<C-u>call SmartBDelete(0)<CR>
nnoremap <silent> <Space>D :<C-u>call SmartBDelete(1)<CR>
"}}}
