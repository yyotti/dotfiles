let s:jobs = {}

function! s:on_stdout(id, data, event) dict "{{{
  if !has_key(s:jobs, a:id)
    return
  endif

  let l:job_opt = s:jobs[a:id]

  " for l:line in a:data
  "   echo printf('[stdout] (%s) %s', l:job_opt.pkg, l:line)
  " endfor
  if has_key(l:job_opt, 'on_stdout') && type(l:job_opt.stdout) ==# v:t_func
    call l:job_opt.stdout(l:job_opt.pkg, a:data)
  endif
endfunction "}}}

function! s:on_stderr(id, data, event) dict "{{{
  if !has_key(s:jobs, a:id)
    return
  endif

  let l:job_opt = s:jobs[a:id]

  for l:line in a:data
    call vimrc#error(printf('[error] (%s) %s', l:job_opt.pkg, l:line))
  endfor
  if has_key(l:job_opt, 'on_stderr') && type(l:job_opt.on_stderr) ==# v:t_func
    call l:job_opt.on_stderr(l:job_opt.pkg, a:data)
  endif
endfunction "}}}

function! s:on_exit(id, data, event) dict "{{{
  if !has_key(s:jobs, a:id)
    return
  endif

  let l:job_opt = s:jobs[a:id]
  unlet s:jobs[a:id]

  " echo printf('[exit] (%s) %d', l:job_opt.pkg, a:data)
  if has_key(l:job_opt, 'on_exit') && type(l:job_opt.on_exit) ==# v:t_func
    call l:job_opt.on_exit(l:job_opt.pkg, a:data)
  endif
endfunction "}}}

function! job#nvim#start(cmd, opts) abort "{{{
  let l:opt = {
      \   'on_stdout': function('s:on_stdout'),
      \   'on_stderr': function('s:on_stderr'),
      \   'on_exit': function('s:on_exit'),
      \ }
  if has_key(a:opts, 'cwd')
    let l:opt.cwd = a:opts.cwd
  endif

  let l:job_id = jobstart(a:cmd, l:opt)
  if l:job_id > 0
    let s:jobs[l:job_id] = a:opts
  endif

  return l:job_id
endfunction "}}}

function! job#nvim#wait(ids, timeout) abort "{{{
  return jobwait(a:ids, a:timeout)
endfunction "}}}
