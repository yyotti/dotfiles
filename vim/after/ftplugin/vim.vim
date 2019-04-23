if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif
let s:undo = []

setlocal iskeyword+=:,#

let &l:path = join(
      \   map(split(&runtimepath, ','), { _, p -> p . '/autoload' }), ','
      \ )

setlocal suffixesadd=.vim
setlocal includeexpr=fnamemodify(substitute(v:fname,'#','/','g'),':h')
call add(s:undo, 'setlocal iskeyword< suffixesadd< includeexpr<')

if !empty(s:undo)
  let b:undo_ftplugin .= join(s:undo, '|')
endif
