command! -nargs=+ GitFile call GitCatFile(0, <f-args>)
command! -nargs=+ GitFileV call GitCatFile(1, <f-args>)

function! GitCatFile(vert, ...) abort "{{{
  if empty(fugitive#head())
    echohl ErrorMsg
    echo 'Not in git repository.'
    echohl None
    return
  endif

  if a:0 < 2
    echohl ErrorMsg
    echo 'GitFile(V) <branch|sha> <fpath>'
    echohl None
    return
  endif

  let l:arg1 = get(a:000, 0, '')
  let l:arg2 = get(a:000, 1, '')
  if empty(l:arg2)
    let l:branch = fugitive#head(getcwd())
    let l:file = l:arg1
  else
    let l:branch = l:arg1
    let l:file = l:arg2
  endif

  let l:cmd = a:vert ? 'vnew' : 'new'
  execute printf('%s %s:%s', l:cmd, l:branch, l:file)
  setlocal bufhidden=hide
  setlocal buftype=nofile
  setlocal noswapfile

  execute printf('read ! git cat-file -p %s:%s', l:branch, l:file)
  normal! ggdd

  setlocal readonly
  setlocal nomodifiable
endfunction "}}}
