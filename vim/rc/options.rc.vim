"-----------------------------------------------------------------------------
" Global Options:
"
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrapscan

set smarttab
set expandtab

set shiftwidth=4
set shiftround

set autoindent
set smartindent

" Clipboard
if (has('nvim') || $DISPLAY !=# '') && has('clipboard')
  set clipboard&
  if has('unnamedplus')
    set clipboard+=unnamedplus
  else
    set clipboard+=unnamed
  endif
endif

set backspace=indent,eol,start

set hidden

" Folding
set foldmethod=marker
set foldcolumn=1
set fillchars=vert:\|
set commentstring=%s

" FastFold
autocmd MyAutocmd TextChangedI,TextChanged *
      \ if &l:foldenable && &l:foldmethod !=# 'manual' |
      \   let b:foldmethod_save = &l:foldmethod |
      \   let &l:foldmethod = 'manual' |
      \ endif
autocmd MyAutocmd BufWritePost *
      \ if &l:foldmethod ==# 'manual' && exists('b:foldmethod_save') |
      \   let &l:foldmethod = b:foldmethod_save |
      \   execute 'normal! zx' |
      \ endif

if exists('*FoldCCtext')
  set foldtext=FoldCCtext()
endif

set grepprg=grep\ -inH

" Exclude = from isfilename
set isfname-==

set timeout
set timeoutlen=3000
set ttimeoutlen=100

set updatetime=1000

" Remove current directory from swap directory
set directory-=.

" Do not create backup
set nowritebackup
set nobackup
set noswapfile
set backupdir-=.

set undofile
let &g:undodir=&directory

set virtualedit=block

set keywordprg=:help

set nrformats=

autocmd MyAutocmd WinEnter * checktime

autocmd MyAutocmd InsertLeave *
      \ if &paste | setlocal nopaste | echo 'nopaste' | endif |
      \ if &l:diff | diffupdate | endif

" Create directory automatically
" http://vim-users.jp/2011/02/hack202/
autocmd MyAutocmd BufWritePre *
      \ call <SID>mkdir_as_necessary(expand('<afile>:p:h'), v:cmdbang)
function! s:mkdir_as_necessary(dir, force) abort "{{{
  if isdirectory(a:dir) || &buftype !=# ''
    return
  endif

  let l:msg = printf('"%s" does not exists. Create ?', a:dir)
  if confirm(l:msg, "&Yes\n&No", 2) ==# 1
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction "}}}

" Remove last whitespaces
autocmd MyAutocmd BufWritePre * call <SID>del_last_whitespaces()
function! s:del_last_whitespaces() abort "{{{
  if !get(b:, 'del_last_whitespaces', 1)
    return
  endif

  if &binary || &diff || !&l:modified
    return
  endif

  let l:cursor = getpos('.')

  global/^/ s/\s\+$//e

  call setpos('.', l:cursor)
  unlet l:cursor
endfunction "}}}

" lcd git root directory
if executable('git')
  autocmd MyAutocmd BufWinEnter * call <SID>cd_gitroot()

  function! s:trim(str) abort "{{{
    return substitute(a:str, '^[\r\n]*\(.\{-}\)[\r\n]*$', '\1', '')
  endfunction "}}}

  function! s:cd_gitroot() abort "{{{
    let l:dir = getcwd()

    let l:buf_path = expand('%:p')
    if !isdirectory(l:buf_path)
      let l:buf_path = fnamemodify(l:buf_path, ':h')
    endif
    if !isdirectory(l:buf_path)
      return
    endif
    execute 'lcd' fnameescape(l:buf_path)

    let l:in_git_dir = s:trim(system('git rev-parse --is-inside-work-tree'))
    if l:in_git_dir !=# 'true'
      execute 'lcd' fnameescape(l:dir)
      return
    endif

    let l:git_root = s:trim(system('git rev-parse --show-toplevel'))
    execute 'lcd' escape(l:git_root, ' ')
  endfunction "}}}
endif

"-----------------------------------------------------------------------------
" View:
"
set number

set list
if IsWindows()
  set listchars=tab:>-,extends:<,trail:-
else
  execute "set listchars=tab:\u00bb\\ "
  execute "set listchars+=eol:\u21b2"
  execute "set listchars+=nbsp:\u2423"
  execute 'set listchars+=trail:-'
  execute "set listchars+=extends:\u27e9"
  execute "set listchars+=precedes:\u27e8"
endif

set laststatus=2
set cmdheight=2

set noshowcmd
set ambiwidth=double

set title
set titlelen=95

set linebreak
execute "set showbreak=\u21aa\\ "
set breakat=\ \	;:,!?
set whichwrap+=h,l,<,>,[,],b,s,~
if exists('+breakindent')
  set breakindent
  set wrap
else
  set nowrap
endif

set diffopt+=vertical

autocmd MyAutocmd BufEnter,BufWinEnter,FilterWritePost *
      \ execute 'setlocal' (&diff ? 'no' : '') . 'cursorline'

set shortmess=aTI
if has('patch-7.4.314')
  set shortmess+=c
else
  autocmd MyAutocmd VimEnter *
        \ highlight ModeMsg guifg=bg guibg=bg |
        \ highlight Question guifg=bg guibg=bg
endif

set t_vb=
set novisualbell
set belloff=all

set wildmenu
set wildmode=full

set history=1000

set showfulltag
set wildoptions=tagfile

if has('nvim')
  set shada=!,'300,<50,s10,h
else
  set viminfo=!,'300,<50,s10,h
endif

" Disable menu
let g:did_install_default_menus = 1

set completeopt=menuone
if has('patch-7.4.775')
  set completeopt+=noinsert
endif
set complete=.
set pumheight=20

set report=0

set nostartofline

" Minimum window width
set winwidth=30
" Minimum window height
set winheight=1
" Maximum command line window
set cmdwinheight=5
set noequalalways

set previewheight=8
set helpheight=12

set ttyfast

set display=lastline

function! WidthPart(str, width) abort "{{{
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

set conceallevel=2
set concealcursor=niv

set colorcolumn=79
