if exists('b:did_vim_ftplugin')
  finish
endif

let b:did_vim_ftplugin = 1

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal shiftwidth< softtabstop< iskeyword< suffixesadd< includeexpr< path<'
let b:undo_ftplugin .= ' | unlet! b:did_vim_ftplugin'

let b:not_del_last_whitespaces = 1

setlocal shiftwidth=2
setlocal softtabstop=2

setlocal iskeyword+=:,#

let &path = join(
      \   map(split(&runtimepath, ','), { _, p -> p . '/autoload' }), ','
      \ )

setlocal suffixesadd=.vim
setlocal includeexpr=fnamemodify(substitute(v:fname,'#','/','g'),':h')
