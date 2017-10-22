if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif

setlocal shiftwidth=2
setlocal softtabstop=2

setlocal iskeyword+=:,#

let &l:path = join(
      \   map(split(&runtimepath, ','), { _, p -> p . '/autoload' }), ','
      \ )

setlocal suffixesadd=.vim
setlocal includeexpr=fnamemodify(substitute(v:fname,'#','/','g'),':h')

let b:undo_ftplugin .= 'setlocal shiftwidth< softtabstop< iskeyword<'
      \ . ' suffixesadd< includeexpr< path<'
