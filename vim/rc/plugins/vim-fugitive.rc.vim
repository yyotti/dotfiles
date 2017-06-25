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

  let arg1 = get(a:000, 0, '')
  let arg2 = get(a:000, 1, '')
  if empty(arg2)
    let branch = fugitive#head(getcwd())
    let file = arg1
  else
    let branch = arg1
    let file = arg2
  endif

  let cmd = a:vert ? 'vnew' : 'new'
  execute printf('%s %s:%s', cmd, branch, file)
  setlocal bufhidden=hide
  setlocal buftype=nofile
  setlocal noswapfile

  execute printf('read ! git cat-file -p %s:%s', branch, file)
  normal! ggdd

  setlocal readonly
  setlocal nomodifiable
endfunction "}}}
