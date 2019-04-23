if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif
let s:undo = []

setlocal foldmethod=indent
setlocal textwidth=80
setlocal smarttab
setlocal expandtab
setlocal nosmartindent
call add(s:undo, 'setlocal foldmethod< textwidth< smarttab< expandtab<'
      \ . ' nosmartindent<')
if !has_key(g:plugs, 'editorconfig-vim')
  setlocal softtabstop=4
  setlocal shiftwidth=4
  call add(s:undo, 'setlocal softtabstop< shiftwidth<')
endif

if !empty(s:undo)
  let b:undo_ftplugin .= join(s:undo, '|')
endif
