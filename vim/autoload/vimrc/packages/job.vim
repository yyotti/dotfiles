let s:save_cpo = &cpoptions
set cpoptions&vim

let s:env = has('nvim') ? 'nvim' : 'vim'

function! vimrc#packages#job#start(command, ...) abort "{{{
  " let Func = function('vimrc#packages#job#' . s:env . '#start')
  " return Func(a:command, a:000)
  return call('vimrc#packages#job#' . s:env . '#start', [ a:command ] + a:000)
endfunction "}}}

function! vimrc#packages#job#is_exited(job_id) abort "{{{
  let Func = function('vimrc#packages#job#' . s:env . '#is_exited')
  return Func(a:job_id)
endfunction "}}}

let &cpoptions = s:save_cpo
unlet s:save_cpo
