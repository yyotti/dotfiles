let s:save_cpo = &cpoptions
set cpoptions&vim

let s:job_idx = 0
let s:jobs = {}

function! vimrc#packages#job#vim#start(command, ...) abort "{{{
  let s:job_idx += 1

  let job_idx = s:job_idx
  let job = job_start(
        \   a:command,
        \   {
        \     'out_cb': { _, msg -> s:out_cb(job_idx, msg) },
        \     'err_cb': { _, msg -> s:err_cb(job_idx, msg) },
        \     'exit_cb': { _, status -> s:exit_cb(job_idx, status) },
        \   }
        \ )

  if job_status(job) !=# 'run'
    return -1
  endif

  let options = get(a:000, 0, {})
  if type(options) !=# v:t_dict
    let options = {}
  endif

  let s:jobs[job_idx] = {
        \   'options': options,
        \   'job': job,
        \ }

  return job_idx
endfunction "}}}

function! s:out_cb(job_id, msg) abort "{{{
  if has_key(s:jobs, a:job_id)
    let options = s:jobs[a:job_id].options
    if has_key(options, 'on_stdout')
          \ && type(options.on_stdout) ==# v:t_func
      call options.on_stdout(a:job_id, split(a:msg, "\n", 1))
    endif
  endif
endfunction "}}}

function! s:err_cb(job_id, msg) abort "{{{
  if has_key(s:jobs, a:job_id)
    let options = s:jobs[a:job_id].options
    if has_key(options, 'on_stderr')
          \ && type(options.on_stderr) ==# v:t_func
      call options.on_stderr(a:job_id, split(a:msg, "\n", 1))
    endif
  endif
endfunction "}}}

function! s:exit_cb(job_id, status) abort "{{{
  if has_key(s:jobs, a:job_id)
    let options = s:jobs[a:job_id].options
    if has_key(options, 'on_exit')
      call options.on_exit(a:job_id, a:status)
    endif
    call remove(s:jobs, a:job_id)
  endif
endfunction "}}}

let &cpoptions = s:save_cpo
unlet s:save_cpo
