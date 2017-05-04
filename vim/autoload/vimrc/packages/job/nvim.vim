let s:save_cpo = &cpoptions
set cpoptions&vim

let s:job_idx = 0
let s:jobs = {}

function! vimrc#packages#job#nvim#start(command, ...) abort "{{{
  let s:job_idx += 1

  let job_idx = s:job_idx
  let job_id = jobstart(
        \   a:command,
        \   {
        \     'on_stdout': { _, data -> s:on_stdout(job_idx, data) },
        \     'on_stderr': { _, data -> s:on_stderr(job_idx, data) },
        \     'on_exit': { _, data -> s:on_exit(job_idx, data) },
        \   }
        \ )

  if job_id <= 0
    return job_id - 1
  endif

  let options = get(a:000, 0, {})
  if type(options) !=# v:t_dict
    let options = {}
  endif

  let s:jobs[job_idx] = {
        \   'options': options,
        \   'job': job_id,
        \ }

  return job_idx
endfunction "}}}

function! s:on_stdout(job_id, data) abort "{{{
  if has_key(s:jobs, a:job_id)
    let options = s:jobs[a:job_id].options
    if has_key(options, 'on_stdout')
          \ && type(options.on_stdout) ==# v:t_func
      call options.on_stdout(a:job_id, a:data)
    endif
  endif
endfunction "}}}

function! s:on_stderr(job_id, data) abort "{{{
  if has_key(s:jobs, a:job_id)
    let options = s:jobs[a:job_id].options
    if has_key(options, 'on_stderr')
          \ && type(options.on_stderr) ==# v:t_func
      call options.on_stderr(a:job_id, a:data)
    endif
  endif
endfunction "}}}

function! s:on_exit(job_id, data) abort "{{{
  if has_key(s:jobs, a:job_id)
    let options = s:jobs[a:job_id].options
    if has_key(options, 'on_exit')
      call options.on_exit(a:job_id, a:data)
    endif
    call remove(s:jobs, a:job_id)
  endif
endfunction "}}}

let &cpoptions = s:save_cpo
unlet s:save_cpo
