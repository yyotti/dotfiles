let s:jobs = {}

let s:job_seq = 0

function! s:on_stdout(id, ch, msg) abort "{{{
  if !has_key(s:jobs, a:id)
    return
  endif

  let l:job_opt = s:jobs[a:id].opt

  let l:lines = split(a:msg, "\n", 1)
  for l:line in l:lines
    echo printf('[stdout] (%s) %s', l:job_opt.pkg, l:line)
  endfor
  if has_key(l:job_opt, 'on_stdout') && type(l:job_opt.stdout) ==# v:t_func
    call l:job_opt.stdout(l:job_opt.pkg, l:lines)
  endif
endfunction "}}}

function! s:on_stderr(id, ch, msg) abort "{{{
  if !has_key(s:jobs, a:id)
    return
  endif

  let l:job_opt = s:jobs[a:id].opt

  let l:lines = split(a:msg, "\n", 1)
  for l:line in l:lines
    call vimrc#error(printf('[stderr] (%s) %s', l:job_opt.pkg, l:line))
  endfor
  if has_key(l:job_opt, 'on_stderr') && type(l:job_opt.on_stderr) ==# v:t_func
    call l:job_opt.on_stderr(l:job_opt.pkg, l:lines)
  endif
endfunction "}}}

function! s:on_exit(id, job, status) abort "{{{
  if !has_key(s:jobs, a:id)
    return
  endif

  let l:job_opt = s:jobs[a:id].opt
  unlet s:jobs[a:id]

  echo printf('[exit] (%s) %d', l:job_opt.pkg, a:status)
  if has_key(l:job_opt, 'on_exit') && type(l:job_opt.on_exit) ==# v:t_func
    call l:job_opt.on_exit(l:job_opt.pkg, a:status)
  endif
endfunction "}}}

function! job#vim#start(cmd, opts) abort "{{{
  let s:job_seq += 1
  let l:job_id = s:job_seq

  let l:opt = {
      \   'out_cb': function('s:on_stdout', [ l:job_id ]),
      \   'err_cb': function('s:on_stderr', [ l:job_id ]),
      \   'exit_cb': function('s:on_exit', [ l:job_id ]),
      \   'mode': 'raw',
      \ }
  if has_key(a:opts, 'cwd')
    let l:opt.cwd = a:opts.cwd
  endif

  let l:job = job_start(a:cmd, l:opt)
  if job_status(l:job) !=? 'run'
    return -1
  endif

  let s:jobs[l:job_id] = {
        \   'opt': a:opts,
        \   'job': l:job,
        \ }

  return l:job_id
endfunction "}}}

function! job#vim#wait(ids, timeout) abort "{{{
  let l:start = reltime()
  let l:exit_code = 0
  let l:ret = []
  for l:id in a:ids
    if l:exit_code != -2
      let l:exit_code = s:wait(l:id, a:timeout, l:start)
    endif
    let l:ret += [ l:exit_code ]
  endfor

  return l:ret
endfunction "}}}

function! s:wait(id, timeout, start) abort "{{{
  if !has_key(s:jobs, a:id)
    return -3
  endif

  let l:job = s:jobs[a:id]
  let l:timeout = a:timeout / 1000.0
  try
    while l:timeout < 0 || reltimefloat(reltime(a:start)) < l:timeout
      let l:info = job_info(l:job.job)
      if l:info.status ==? 'dead'
        return l:info.exitval
      elseif l:info.status ==? 'fail'
        return -3
      endif

      sleep 1m
    endwhile
  catch /^Vim:Interrupt$/
    return -2
  endtry

  return -1
endfunction "}}}
