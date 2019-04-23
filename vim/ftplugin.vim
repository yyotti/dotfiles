if exists('g:did_load_ftplugin')
  finish
endif

let g:did_load_ftplugin = 1

autocmd MyAutocmd FileType * call s:ftplugin()

function! s:ftplugin() abort "{{{
  let l:ft = expand('<amatch>')
  call s:reload_ftplugin(l:ft)
  call s:after_ftplugin(l:ft)
endfunction "}}}

function! s:reload_ftplugin(ft) abort "{{{
  if exists('b:undo_ftplugin')
    silent! execute b:undo_ftplugin
    unlet! b:undo_ftplugin b:did_ftplugin
  endif

  if a:ft ==# ''
    return
  endif

  if exists('b:did_ftplugin')
    unlet b:did_ftplugin
  endif

  for l:f in split(a:ft, '\.')
    execute 'runtime!' join([
          \   'ftplugin/' . l:f . '.vim',
          \   'ftplugin/' . l:f . '_*.vim',
          \   'ftplugin/' . l:f . '/*.vim',
          \ ])
  endfor
endfunction "}}}

function! s:after_ftplugin(ft)
  setlocal formatoptions-=ro
  setlocal formatoptions+=mMBl

  if &l:textwidth != 70 && a:ft !=# 'help'
    setlocal textwidth=0
  endif

  if a:ft !=# 'help' && exists('*FoldCCtext')
    setlocal foldtext=FoldCCtext()
  endif

  if !&l:modifiable
    setlocal nofoldenable
    setlocal foldcolumn=0
    setlocal colorcolumn=
  endif
endfunction
