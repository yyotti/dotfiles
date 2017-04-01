if exists('g:did_loaded_after_ftplugin')
  finish
endif
let g:did_load_after_ftplugin = 1

autocmd filetypeplugin FileType * call s:AfterFTPlugin()
function! s:AfterFTPlugin()
  " Disable automatically insert comment
  setlocal formatoptions-=ro
  setlocal formatoptions+=mMBl

  " Disable auto wrap
  if &l:textwidth != 70 && &filetype !=# 'help'
    setlocal textwidth=0
  endif

  " Use foldCCtext()
  if &filetype !=# 'help' && exists('*FoldCCtext')
    setlocal foldtext=FoldCCtext()
  endif

  if !&l:modifiable
    setlocal nofoldenable
    setlocal foldcolumn=0

    if v:version >= 703
      setlocal colorcolumn=
    endif
  endif
endfunction
