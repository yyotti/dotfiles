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

" Disable modeline
set modelines=0
set nomodeline

" Clipboard
if has('clipboard')
  set clipboard&
  if has('unnamedplus')
    set clipboard+=unnamedplus
  else
    set clipboard+=unnamed
  endif
endif

set backspace=indent,eol,start

set matchpairs+=<:>

set hidden

set foldenable
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
let &g:undodir = &directory

set virtualedit=block

set keywordprg=:help

" 00 -> 01
set nrformats=

autocmd MyAutocmd WinEnter * checktime

autocmd MyAutocmd InsertLeave *
      \ if &paste | setlocal nopaste | echo 'nopaste' | endif |
      \ if &l:diff | diffupdate | endif

if !dein#tap('editorconfig-vim')
  " Remove last whitespaces
  autocmd MyAutocmd BufWritePre * call vimrc#del_last_whitespaces()
endif

" Use autofmt.
set formatexpr=autofmt#japanese#formatexpr()

" lcd git root directory
if executable('git')
  autocmd MyAutocmd BufWinEnter * call vimrc#cd_gitroot()
endif

"-----------------------------------------------------------------------------
" View:
"
set number

set list
execute "set listchars=tab:\u00bb\\ "
execute "set listchars+=eol:\u21b2"
execute "set listchars+=nbsp:\u2423"
execute 'set listchars+=trail:-'
execute "set listchars+=extends:\u27e9"
execute "set listchars+=precedes:\u27e8"

set laststatus=2
set cmdheight=2

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

autocmd MyAutocmd BufEnter,BufWinEnter,FilterWritePost *
      \ execute 'setlocal' (&diff ? 'no' : '') . 'cursorline'
set diffopt+=vertical

" a: all of the [f,i,l,m,n,r,w,x] abbreviations
" T: truncate other messages in the middle if they are too long to
"    fit on the command line.  "..." will appear in the middle.
"    Ignored in Ex mode.
" I: don't give the intro message when starting Vim |:intro|.
" c: don't give |ins-completion-menu| messages.  For example,
"    "-- XXX completion (YYY)", "match 1 of 2", "The only match",
"    "Pattern not found", "Back at original", etc.
" F: don't give the file info when editing a file, like `:silent`
"    was used for the command
set shortmess=aTIcF

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

set completeopt=menuone,noinsert
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

set conceallevel=2
set concealcursor=niv

set colorcolumn=79
