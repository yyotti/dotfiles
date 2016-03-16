let s:save_cpo = &cpoptions
set cpoptions&vim

if executable('sql-formatter')
  setlocal formatexpr=
  setlocal formatprg=sql-formatter
endif

let &cpoptions = s:save_cpo
unlet s:save_cpo
