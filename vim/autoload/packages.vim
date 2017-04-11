let s:save_cpo = &cpoptions
set cpoptions&vim

let s:plugins = {}

let s:default_options = {
      \   'condition': 1,
      \   'depends': [],
      \   'path': '',
      \ }

function! packages#begin(...) abort "{{{
  let s:plugins = {}

  if v:version < 800 || !has('patch-8.0.308')
    let &runtimepath = join(
          \   map(
          \     split(&runtimepath, ','),
          \     { _, p -> resolve(fnamemodify(p, ':p')) }
          \   ),
          \   ','
          \ )
    let &packpath = join(
          \   map(
          \     split(&packpath, ','),
          \     { _, p -> resolve(fnamemodify(p, ':p')) }
          \   ),
          \   ','
          \ )
  endif

  let s:packpath = get(a:000, 0, get(split(&packpath, ','), 0, ''))
  if empty(s:packpath)
    echomsg 'Invalid packpath: ' . s:packpath
    return 0
  endif
  execute 'set packpath+=' . s:packpath

  if exists('g:did_load_filetypes') || has('nvim')
    filetype off
  endif
  if exists('b:did_indent') || exists('b:did_ftplugin')
    filetype plugin indent off
  endif

  autocmd MyAutocmd VimEnter *
        \ call timer_start(1, function('packages#load_plugins'))

  augroup plugin-packages
    autocmd!
  augroup END

  return 1
endfunction "}}}

function! packages#end() abort "{{{
  let s:plugins = s:remove_disabled_plugins(s:plugins)
endfunction "}}}

function! packages#add(plugin, ...) abort "{{{
  if a:plugin !~# '[^/]\+/[^/]\+'
    return {}
  endif

  let name = split(a:plugin, '/')[1]

  let options =
        \ extend(copy(s:default_options), s:check_options(a:000), 'force')

  let options['rtp'] = s:join_path(
        \   resolve(expand(split(&packpath, ',')[0])),
        \   a:plugin,
        \   options['path']
        \ )

  if has_key(s:plugins, name)
    let s:plugins[name] = extend(copy(s:plugins[name]), options, 'force')
  else
    let s:plugins[name] = options
  endif

  return s:plugins[name]
endfunction "}}}

function! packages#post_add() abort "{{{
  for plugin in keys(s:plugins)
    call s:call_hook(plugin, 'post_add')
  endfor
endfunction "}}}

function! packages#get(plugin) abort "{{{
  return get(s:plugins, a:plugin, {})
endfunction "}}}

function! packages#load_plugins(...) abort "{{{
  for plugin in keys(s:plugins)
    call s:call_hook(plugin, 'pre_add')
  endfor

  let dependencies = s:flatten(
        \   map(
        \     filter(values(s:plugins), { _, op -> !empty(op['depends']) }),
        \     { _, op -> op['depends'] }
        \   )
        \ )
  for plugin in dependencies
    execute 'packadd!' plugin
  endfor

  let s:loding_plugins = {}
  for plugin in keys(s:plugins)
    call timer_start(1, function('s:packadd', [ plugin, 0 ]))
    let s:loding_plugins[plugin] = 1
  endfor
endfunction "}}}

function! packages#filetype_on(...) abort "{{{
  if execute('filetype') =~# 'OFF'
    filetype plugin indent on
    syntax enable
    filetype detect
  endif
endfunction "}}}

function! s:packadd(name, bang, ...) abort "{{{
  let plugin = get(s:plugins, a:name, {})
  if empty(plugin)
    return
  endif

  execute 'packadd' . (a:bang ? '!' : '') s:join_path(a:name, plugin['path'])

  if !a:bang
    call s:plugin_loaded(a:name, a:000)
  endif
endfunction "}}}

function! s:plugin_loaded(name, ...) abort "{{{
  unlet! s:loding_plugins[a:name]
  if !empty(s:loding_plugins)
    return
  endif

  for plugin in keys(s:plugins)
    call s:call_hook(plugin, 'post_add')
  endfor

  call packages#filetype_on()
  doautocmd User post-plugins-loaded
endfunction "}}}

function! s:flatten(list) abort "{{{
  if type(a:list) !=# v:t_list
    return [ a:list ]
  endif

  let flat_list = []
  for elem in a:list
    let flat_list += s:flatten(elem)
  endfor

  return flat_list
endfunction "}}}

function! s:check_options(options) abort "{{{
  if empty(a:options) || type(a:options[0]) !=# v:t_dict || empty(a:options[0])
    return {}
  endif

  let op = copy(a:options[0])

  if has_key(op, 'condition') && type(op['condition']) ==# v:t_func
    let op['condition'] = op['condition']()
  endif

  for key in [ 'init', 'post_add' ]
    if has_key(op, key)
          \ && index([ v:t_func, v:t_string ], type(op[key])) < 0
      unlet op[key]
    endif
  endfor

  if has_key(op, 'depends')
    if index([ v:t_string, v:t_list ], type(op['depends'])) < 0
          \ || empty(op['depends'])
      unlet op['depends']
    elseif type(op['depends']) ==# v:t_string
      let op['depends'] = [ op['depends'] ]
    endif
  endif
  if has_key(op, 'depends')
    let op['depends'] = uniq(sort(copy(op['depends'])))
  endif

  if has_key(op, 'path')
        \ && (type(op['path']) !=# v:t_string || empty(op['path']))
    unlet op['depends']
  endif

  return op
endfunction "}}}

function! s:remove_disabled_plugins(options) abort "{{{
  " Available plugins
  let options = filter(copy(a:options), { _, op -> op['condition'] })

  let changed = 0
  for plugin in keys(filter(copy(options), { _, op -> !empty(op['depends']) }))
    let depends = options[plugin]['depends']
    for p in depends
      if !has_key(options, p)
        let options[plugin]['condition'] = 0
        let changed = 1
        break
      endif
    endfor
  endfor

  return changed ? s:remove_disabled_plugins(options) : options
endfunction "}}}

function! s:call_hook(plugin, hook) abort "{{{
  if has_key(s:plugins[a:plugin], a:hook)
    " Because of:
    "   E704: Funcref variable name must start with a capital: init
    let s:hook = s:plugins[a:plugin][a:hook]
    if type(s:hook) ==# v:t_string
      if !empty(s:hook)
        execute 'source' fnameescape(s:hook)
      endif
    else
      call call(s:hook, [], s:plugins[a:plugin])
    endif
    unlet s:hook
  endif
endfunction "}}}

function! s:join_path(base, ...) abort "{{{
  let paths = filter(
        \   map(
        \     map(
        \       copy(a:000),
        \       { _, part -> type(part) !=# v:t_string ? string(part) : part }
        \     ),
        \     { _, val ->
        \       join(filter(split(val, '/'), { _, val -> !empty(val) }), '/') }
        \   ),
        \   { _, val -> !empty(val) }
        \ )
  return empty(paths) ? a:base : join([ a:base ] + paths, '/')
endfunction "}}}

let &cpoptions = s:save_cpo
unlet s:save_cpo
