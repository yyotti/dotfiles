"-----------------------------------------------------------------------------
" dein.rc.vim:
"

" DeinClean command
command! -bang DeinClean call s:dein_clean(<bang>0)

function! s:dein_clean(force) abort "{{{
  let added_plugins = values(map(dein#get(), 'v:val.path'))

  let repos = expand($CACHE . '/dein/repos/github.com')
  let plugin_dirs = filter(glob(repos . '/*/*', 0, 1), 'isdirectory(v:val)')

  let unused_plugins = filter(plugin_dirs, 'index(added_plugins, v:val) < 0')

  let del_all = a:force
  for p in unused_plugins
    if !del_all
      let answer = s:input(printf('Delete %s ? [y/N]', fnamemodify(p, ':~')))

      if type(answer) is type(0) && answer <= 0
        " Cancel (Esc or <C-c> or 'q')
        break
      endif

      if answer !~? '^\(y\%[es]\|a\%[ll]\)$'
        continue
      endif

      if answer =~? '^a\%[ll]$'
        let del_all = 1
      endif
    endif

    " Delete plugin dir
    call dein#install#_rm(p)
  endfor
endfunction "}}}

function! s:input(...) abort "{{{
  new
  cnoremap <buffer> <Esc> __CANCELED__<CR>
  try
    let input = call('input', a:000)
    let input = input =~# '__CANCELED__$' ? 0 : input
  catch /^Vim:Interrupt$/
    let input = -1
  finally
    bwipeout!
    return input
  endtry
endfunction "}}}
