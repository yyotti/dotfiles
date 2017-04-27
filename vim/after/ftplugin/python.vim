if exists('b:did_python_ftplugin')
  finish
endif

let b:did_python_ftplugin = 1

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal foldmethod< textwidth< smarttab< expandtab<' .
      \ ' smartindent< omnifunc< completeopt< foldnestmax<'
let b:undo_ftplugin .= ' | unlet! b:did_python_ftplugin'

setlocal foldmethod=indent
setlocal textwidth=80
setlocal smarttab
setlocal expandtab
setlocal nosmartindent
setlocal foldnestmax=1

if !empty(packages#get('davidhalter/jedi-vim'))
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

  " sort imports
  function! SortImports() abort "{{{
    if !&l:modified
      return
    endif

    let start = 0
    let end = 0

    let lineno = 0
    for line in getbufline(bufnr('%'), 1, '$')
      let lineno += 1
      if line =~# '^import ' && start <= 0
        let start = lineno
      elseif line !~# '^import ' && start > 0
        let end = lineno - 1
        break
      endif
    endfor
    if start > 0 && end == 0
      let end = lineno
    endif

    if start > 0 && end > 0 && start <= end
      let pos = getpos('.')

      let cmd = printf('%d,%dsort', start, end)
      execute cmd

      call setpos('.', pos)
      unlet pos
    endif
  endfunction "}}}

  autocmd! MyAutocmd BufWritePre <buffer> call SortImports()
endif
