if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif

setlocal foldmethod=indent
setlocal textwidth=80
setlocal smarttab
setlocal expandtab
setlocal nosmartindent

let b:undo_ftplugin .= 'setlocal foldmethod< textwidth< smarttab<'
      \ . ' expandtab< smartindent<'

if pack#has('davidhalter/jedi-vim')
  setlocal omnifunc=jedi#completions

  function! JediRename() abort "{{{
    normal! zn
    call jedi#rename()
  endfunction "}}}

  " mappings
  nnoremap <silent> <buffer> <LocalLeader>g
        \ :<C-u>call jedi#goto()<CR>
  nnoremap <silent> <buffer> <LocalLeader>a
        \ :<C-u>call jedi#goto_assignments()<CR>
  nnoremap <silent> <buffer> <LocalLeader>d
        \ :<C-u>call jedi#goto_definitions()<CR>
  nnoremap <silent> <buffer> <LocalLeader>r
        \ :<C-u>call JediRename()<CR>
  nnoremap <silent> <buffer> <LocalLeader>i
        \ :<C-u>call SortImports()<CR>

  " sort imports
  function! SortImports() abort "{{{
    if !&l:modified
      return
    endif

    let l:start = 0
    let l:end = 0

    let l:lineno = 0
    for l:line in getbufline(bufnr('%'), 1, '$')
      let l:lineno += 1
      if l:line =~# '^import ' && l:start <= 0
        let l:start = l:lineno
      elseif l:line !~# '^import ' && l:start > 0
        let l:end = l:lineno - 1
        break
      endif
    endfor
    if l:start > 0 && l:end == 0
      let l:end = l:lineno
    endif

    if l:start > 0 && l:end > 0 && l:start <= l:end
      let l:pos = getpos('.')

      let l:cmd = printf('%d,%dsort', l:start, l:end)
      execute l:cmd

      call setpos('.', l:pos)
      unlet l:pos
    endif
  endfunction "}}}

  " TODO undo_ftplugin
endif
