let s:vimtype = ''
if has('nvim')
  let s:vimtype = 'nvim'
" FIXME 'cwd' option
" elseif has('timer') && has('channel') && has('job')
elseif has('patch-8.0.0902')
  let s:vimtype = 'vim'
endif

let s:jobstart = function('job#' . s:vimtype . '#start')
let s:jobwait = function('job#' . s:vimtype . '#wait')

function! job#start(cmd, opts) abort "{{{
  if empty(s:vimtype)
    throw 'Not supported version.'
  endif

  return s:jobstart(a:cmd, a:opts)
endfunction "}}}

function! job#wait(ids, ...) abort "{{{
  let l:timeout = -1
  if a:0 > 0 && type(a:1) ==# v:t_number && a:1 > 0
    let l:timeout = a:1
  endif
  return s:jobwait(a:ids, l:timeout)
endfunction "}}}
