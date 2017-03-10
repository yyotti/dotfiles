let s:save_cpo = &cpoptions
set cpoptions&vim

setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=80
setlocal smarttab
setlocal expandtab
setlocal nosmartindent

let &cpoptions = s:save_cpo
unlet s:save_cpo
