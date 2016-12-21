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
  execute "set listchars+=trail:-"
  execute "set listchars+=extends:\u27e9"
  execute "set listchars+=precedes:\u27e8"
endif

set laststatus=2
set cmdheight=2

set showcmd
set ambiwidth=double

set title
set titlelen=95
let &titlestring = "%{expand('%:p:~:.')}%(%m%r%w%)"
      \ . '%< (%{WidthPart('
      \ . "fnamemodify(&filetype ==# 'vimfiler' ?"
      \ . "substitute(b:vimfiler.current_dir,'.\\zs/$','',''):getcwd(),':~'),"
      \ . "&columns-len(expand('%:p:.:~')))}\) - VIM"

if !IsPowerlineEnabled()
  let &statusline = "%{winnr('$')>1?'['.winnr().'/'.winnr('$')"
        \ . ".(winnr('#')==winnr()?'#':'').']':''}\ "
        \ . "%{(&previewwindow?'[preview] ':'').expand('%:t')}"
        \ . "\ %=%{(winnr('$')==1 || winnr('#')!=winnr()) ?"
        \ . "'['.(&filetype!=''?&filetype.',':'')"
        \ . ".(&fenc!=''?&fenc:&enc).','.&ff.']' : ''}"
        \ . "%m%{printf('%'.(len(line('$'))+2).'d/%d',line('.'),line('$'))}"
        \ . "%{exists('*qfstatusline#Update')?qfstatusline#Update():''}"
endif

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

autocmd MyAutocmd BufEnter,BufWinEnter *
      \ execute 'setlocal' (&diff ? 'no' : '') . 'cursorline'

set shortmess=aTI
if has('patch-7.4.314')
  set shortmess+=c
else
  autocmd MyAutocmd VimEnter *
        \ highlight ModeMsg guifg=bg guibg=bg |
        \ highlight Question guifg=bg guibg=bg
endif
if has('patch-7.4.1570')
  set shortmess+=F
endif

set wildmenu
set wildmode=full

if !has('nvim')
  set history=1000
endif

set showfulltag
set wildoptions=tagfile

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

  let ret = a:str
  let width = strwidth(a:str)
  while width > a:width
    let char = matchstr(ret, '.$')
    let ret = ret[: -1 - len(char)]
    let width -= strwidth(char)
  endwhile

  return ret
endfunction "}}}

set conceallevel=2
set concealcursor=niv

set colorcolumn=79
