function! vimrc#toggle_option(option_name) abort "{{{
  execute 'setlocal' a:option_name.'!'
  execute 'setlocal' a:option_name.'?'
endfunction "}}}

function! vimrc#toggle_cmdline_word_boundary() abort "{{{
  let l:cmdline = getcmdline()
  if getcmdtype() !=# '/' && getcmdtype() !=# '?'
    return l:cmdline
  endif

  let l:magic = ''
  if l:cmdline =~# '^\\[vVmM]'
    let l:magic = l:cmdline[:1]
    let l:cmdline = l:cmdline[2:]
  endif

  if l:magic ==# '\v'
    let l:start = '<'
    let l:end = '>'
    let l:regex = '^<.*>$'
  else
    let l:start = '\<'
    let l:end = '\>'
    let l:regex = '^\\<.*\\>$'
  endif
  if l:cmdline !~# l:regex
    let l:cmdline = printf('%s%s%s', l:start, l:cmdline, l:end)
  else
    let l:cmdline = l:cmdline[len(l:start):len(l:cmdline) - len(l:end) - 1]
  endif

  return l:magic . l:cmdline
endfunction "}}}

function! vimrc#automark() abort "{{{
  let b:marker_idx = (get(b:, 'marker_idx', -1) + 1) % len(g:marker_chars)
  let l:char = g:marker_chars[b:marker_idx]
  execute 'mark' l:char
  echo printf('marked [%s]', l:char)
endfunction "}}}

function! vimrc#trim(str) abort "{{{
  return substitute(a:str, '^[\r\n]*\(.\{-}\)[\r\n]*$', '\1', '')
endfunction "}}}

function! vimrc#cd_gitroot() abort "{{{
  " TODO Improve
  let l:dir = getcwd()

  let l:buf_path = expand('%:p')
  if !isdirectory(l:buf_path)
    let l:buf_path = fnamemodify(l:buf_path, ':h')
  endif
  if !isdirectory(l:buf_path)
    return
  endif
  execute 'lcd' fnameescape(l:buf_path)

  let l:in_git_dir = vimrc#trim(system('git rev-parse --is-inside-work-tree'))
  if l:in_git_dir !=# 'true'
    execute 'lcd' fnameescape(l:dir)
    return
  endif

  let l:git_root = vimrc#trim(system('git rev-parse --show-toplevel'))
  execute 'lcd' escape(l:git_root, ' ')
endfunction "}}}

function! vimrc#smart_bdelete(force) abort "{{{
  let l:cur_bufnr = bufnr('%')
  let l:alt_bufnr = bufnr('#')

  if buflisted(l:alt_bufnr)
    buffer #
  else
    bnext
  endif

  if bufnr('%') ==# l:cur_bufnr
    " bwipeout is failed when !force and buffer is modified
    if a:force || !&l:modified
      new
    endif
  endif

  if buflisted(l:cur_bufnr)
    execute 'silent bwipeout' . (a:force ? '!' : '') l:cur_bufnr
    " restore buffer when bwipeout is failed
    if bufloaded(l:cur_bufnr)
      execute 'buffer' l:cur_bufnr
    endif
  endif
endfunction "}}}

function! vimrc#smart_ctrl_u() abort "{{{
  let l:cmdline = getcmdline()
  if (getcmdtype() ==# '/' || getcmdtype() ==# '?') &&
        \ l:cmdline =~# '^\\[vVmM]'
    " Using magic
    return l:cmdline[:1]
  endif

  return ''
endfunction "}}}
