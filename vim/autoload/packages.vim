let s:save_cpo = &cpoptions
set cpoptions&vim

let s:plugin_options = {}
let s:available_plugins = []

let s:default_options = {
      \   'condition': 1,
      \   'depends': [],
      \ }

function! packages#begin(packpath) abort "{{{
  let s:plugin_options = {}
  let s:available_plugins = []

  if exists('g:did_load_filetypes') || has('nvim')
    filetype off
  endif
  if exists('b:did_indent') || exists('b:did_ftplugin')
    filetype plugin indent off
  endif

  set runtimepath&
  if type(a:packpath) !=# type('') || empty(a:packpath)
    set packpath&
  else
    execute 'set packpath=' . a:packpath
  endif
endfunction "}}}

function! packages#end() abort "{{{
  let s:available_plugins =
        \ s:remove_disabled_plugins(keys(s:plugin_options), s:plugin_options)

  for plugin in s:available_plugins
    execute 'packadd!' plugin
    call s:call_hook(plugin, 'init')
  endfor
endfunction "}}}

function! packages#add(plugin, ...) abort "{{{
  let options =
        \ extend(copy(s:default_options), s:check_options(a:000), 'force')

  let options['rtp'] = 
        \ resolve(expand(split(&packpath, ',')[0])) . '/' . a:plugin

  if has_key(s:plugin_options, a:plugin)
    let s:plugin_options[a:plugin] =
          \ extend(copy(s:plugin_options[a:plugin]), options, 'force')
  else
    let s:plugin_options[a:plugin] = options
  endif

  return s:plugin_options[a:plugin]
endfunction "}}}

function! packages#post_add() abort "{{{
  for plugin in s:available_plugins
    call s:call_hook(plugin, 'post_add')
  endfor
endfunction "}}}

function! packages#get(plugin) abort "{{{
  let idx = index(get(s:, 'available_plugins', []), a:plugin)
  return idx < 0 ? {} : s:plugin_options[a:plugin]
endfunction "}}}

function! s:flatten(list) abort "{{{
  if type(a:list) !=# type([])
    return [ a:list ]
  endif

  let flat_list = []
  for elem in a:list
    let flat_list += s:flatten(elem)
  endfor

  return flat_list
endfunction "}}}

function! s:check_options(options) abort "{{{
  if empty(a:options) || type(a:options[0]) !=# type({}) || empty(a:options[0])
    return {}
  endif

  let op = copy(a:options[0])

  if has_key(op, 'condition') && type(op['condition']) ==# type(function('tr'))
    let op['condition'] = op['condition']()
  endif

  for key in [ 'init', 'post_add' ]
    if has_key(op, key)
          \ && index([ type(function('tr')), type('') ], type(op[key])) < 0
      unlet op[key]
    endif
  endfor

  if has_key(op, 'depends')
    if index([ type(''), type([]) ], type(op['depends'])) < 0
          \ || empty(op['depends'])
      unlet op['depends']
    elseif type(op['depends']) ==# type('')
      let op['depends'] = [ op['depends'] ]
    endif
  endif

  return op
endfunction "}}}

function! s:remove_disabled_plugins(list, options) abort "{{{
  " Available plugins
  let available_plugins = filter(copy(a:options), 'v:val.condition')
  let list = filter(copy(a:list), 'has_key(available_plugins, v:val)')

  let changed = 0
  for plugin in filter(copy(list),
        \ '!empty(available_plugins[v:val]["depends"])')
    let depends = a:options[plugin]['depends']
    for p in depends
      if !has_key(available_plugins, p)
        let a:options[plugin]['condition'] = 0
        let changed = 1
      endif
    endfor
  endfor

  return changed ? s:remove_disabled_plugins(list, available_plugins) : list
endfunction "}}}

function! s:call_hook(plugin, hook) abort "{{{
  if has_key(s:plugin_options[a:plugin], a:hook)
    " Because of:
    "   E704: Funcref variable name must start with a capital: init
    let s:hook = s:plugin_options[a:plugin][a:hook]
    if type(s:hook) ==# type('')
      if !empty(s:hook)
        execute 'source' fnameescape(s:hook)
      endif
    else
      call call(s:hook, [], s:plugin_options[a:plugin])
    endif
    unlet s:hook
  endif
endfunction "}}}

let &cpoptions = s:save_cpo
unlet s:save_cpo
