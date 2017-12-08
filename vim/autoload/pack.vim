let s:packages = {}

let s:option_base = {
      \   'url': '',
      \   'name': '',
      \   'enabled': v:true,
      \   'depends': [],
      \   'build': [],
      \
      \   '_path': '',
      \   '_installed': v:false,
      \   '_sourced': v:false,
      \ }

let s:packpath = ''

let s:jobs = {}

let s:job_max = 5

function! pack#init() abort "{{{
  let s:packages = {}

  let l:packpath = &packpath
  if empty(&packpath)
    let l:packpath = '~/.cache/vim'
  else
    let l:packpath = split(&packpath, ',')[0]
  endif

  let l:packpath = fnamemodify(expand(l:packpath), ':p')
  if !isdirectory(l:packpath)
    call mkdir(l:packpath, 'p')
  endif

  let s:packpath = l:packpath

  let l:vimhome = split(&runtimepath, ',')[0]
  execute 'set runtimepath-=' . l:vimhome
  execute 'set runtimepath-=' . l:packpath
  execute 'set runtimepath^=' . l:vimhome . ',' . l:packpath
endfunction "}}}

function! pack#add(repo, ...) abort "{{{
  if a:0 > 0
    let l:packopt = extend(copy(s:option_base), a:000[0], 'force')
  else
    let l:packopt = copy(s:option_base)
  endif

  if empty(l:packopt.url)
    let l:packopt.url =
          \ vimrc#join_path('https://github.com', a:repo . '.git')
  endif

  if empty(l:packopt.name)
    let l:packopt.name = split(a:repo, '/')[-1]
  endif

  let l:packopt._path = vimrc#join_path(
        \   s:packpath,
        \   'pack',
        \   'bundle',
        \   'opt',
        \   l:packopt.name
        \ )
  let l:packopt._installed = isdirectory(l:packopt._path)

  let s:packages[a:repo] = l:packopt

  return l:packopt
endfunction "}}}

function! pack#end() abort "{{{
  call s:packinit()
  call s:packadd_all()
  call s:packadded()
endfunction "}}}

function! pack#has(key) abort "{{{
  return has_key(s:packages, a:key)
        \ && s:packages[a:key]._installed && s:packages[a:key].enabled
endfunction "}}}

function! s:packinit() abort "{{{
  let l:packages = filter(copy(s:packages),
        \ { _, p -> p.enabled && p._installed &&
        \   has_key(p, 'init') && type(p.init) ==# v:t_func })
  for l:pack in keys(l:packages)
    call l:packages[l:pack].init()
  endfor
endfunction "}}}

function! s:packadd_all() abort "{{{
  let l:packages = filter(copy(s:packages),
        \ { _, p -> p.enabled && p._installed && !p._sourced })

  for l:pack in keys(l:packages)
    call s:packadd(l:pack)
  endfor
endfunction "}}}

function! s:packadd(pack) abort "{{{
  if !has_key(s:packages, a:pack)
    return v:false
  endif

  let l:pack = s:packages[a:pack]
  if !l:pack.enabled || !l:pack._installed
    return v:false
  endif

  if l:pack._sourced
    return v:true
  endif

  let l:depends_added = v:true
  if has_key(l:pack, 'depends')
    let l:depends = l:pack.depends
    if type(l:depends) !=# v:t_list
      let l:depends = [ string(l:depends) ]
    endif

    for l:d in l:depends
      let l:depends_added = l:depends_added && s:packadd(l:d)
      if !l:depends_added
        return v:false
      endif
    endfor
  endif

  execute 'packadd' l:pack.name
  let l:pack._sourced = v:true

  return v:true
endfunction "}}}

function! s:packadded() abort "{{{
  let l:packages = filter(copy(s:packages),
        \ { _, p -> p.enabled && p._installed && p._sourced &&
        \   has_key(p, 'added') && type(p.added) ==# v:t_func })
  for l:pack in keys(l:packages)
    call l:packages[l:pack].added()
  endfor
endfunction "}}}

function! pack#check_install(...) abort "{{{
  let l:packages = filter(copy(s:packages),
        \ { _, p -> p.enabled && !p._installed })
  if a:0 > 0
    let l:packages = filter(copy(l:packages), { k -> index(a:000, k) >= 0 })
  endif

  return l:packages
endfunction "}}}

function! pack#install(pkgs) abort "{{{
  " TODO When press C-c (cancelled)
  let s:jobs = {}
  for l:k in keys(a:pkgs)
    while len(s:jobs) >= s:job_max
      sleep 1m
    endwhile

    let l:pkg = s:packages[l:k]
    if l:pkg._installed
      return
    endif

    let l:commands = {
          \   'clone': [ 'git', 'clone', '--quiet', l:pkg.url, l:pkg._path ],
          \ }
    if has_key(l:pkg, 'build')
      let l:commands.build = l:pkg.build
    endif

    let l:job_id = s:install(l:k, l:commands)
    if l:job_id <= 0
      call vimrc#error('Job start error: Installing ' . l:k)
      continue
    endif

    let s:jobs[l:k] = l:job_id
  endfor

  while len(s:jobs) > 0
    sleep 1m
  endwhile

  let l:remote_plugins = filter(values(a:pkgs),
        \ { _, v -> isdirectory(vimrc#join_path(v._path, 'rplugin')) })
  if !empty(l:remote_plugins) && exists(':UpdateRemotePlugins') ==# 2
    for l:p in l:remote_plugins
      execute 'packadd!' l:p.name
    endfor
    UpdateRemotePlugins
    echo 'executed UpdateRemotePlugins'
  endif
endfunction "}}}

function! s:install(pkg_key, commands) abort "{{{
  let l:opt = {
        \   'pkg': a:pkg_key,
        \   'on_exit': function('s:on_install_finished'),
        \ }

  echo printf('Installing [%s]', a:pkg_key)

  return job#start(a:commands.clone, l:opt)
endfunction "}}}

function! s:on_install_finished(pkg_key, code) abort "{{{
  call s:build(a:pkg_key)
  call s:helptags(a:pkg_key)

  if has_key(s:jobs, a:pkg_key)
    unlet s:jobs[a:pkg_key]
  endif
endfunction "}}}

function! s:build(pkg_key) abort "{{{
  let l:pkg = s:packages[a:pkg_key]
  if !has_key(l:pkg, 'build') || empty(l:pkg.build)
    return
  endif

  echo printf('Building [%s]', a:pkg_key)

  let l:opt = {
        \   'pkg': a:pkg_key,
        \   'cwd': l:pkg._path,
        \ }

  for l:cmd in l:pkg.build
    let l:job_id = job#start(l:cmd, l:opt)
    if l:job_id <= 0
      call vimrc#error('Job start error')
      break
    endif

    let l:build_exit = job#wait([ l:job_id ])
    if l:build_exit[0] < 0
      if l:build_exit[0] ==# -2
        " FIXME
        echomsg 'Interrupted'
        return
      endif

      call vimrc#error(printf('Build failed [%s]', a:pkg_key))
      break
    endif
  endfor
endfunction "}}}

function! s:helptags(pkg_key) abort "{{{
  let l:doc_path = vimrc#join_path(s:packages[a:pkg_key]._path, 'doc')
  if filewritable(l:doc_path) ==# 2
    execute 'helptags' l:doc_path
  endif
endfunction "}}}
