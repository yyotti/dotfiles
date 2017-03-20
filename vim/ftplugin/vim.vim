let s:save_cpo = &cpoptions
set cpoptions&vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin = ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal modeline<'

setlocal shiftwidth=2
setlocal softtabstop=2

setlocal iskeyword+=:,#

let &path = join(map(split(&runtimepath, ','), "v:val.'/autoload'"), ',')
setlocal suffixesadd=.vim
setlocal includeexpr=fnamemodify(substitute(v:fname,'#','/','g'),':h')

let &cpoptions = s:save_cpo
unlet s:save_cpo
