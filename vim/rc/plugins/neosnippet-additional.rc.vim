"-----------------------------------------------------------------------------
" neosnippet-additional
"
if !exists('g:neosnippet#snippets_directory')
  let g:neosnippet#snippets_directory = ''
endif

let s:snippets_dir =
      \ expand(dein#get('neosnippet-additional').path . '/snippets/')
let s:dirs = split(g:neosnippet#snippets_directory, ',')
for s:dir in s:dirs
  if s:dir ==# s:snippets_dir
    finish
  endif

  unlet s:dir
endfor

let g:neosnippet#snippets_directory = join(add(s:dirs, s:snippets_dir), ',')

unlet s:dirs
unlet s:snippets_dir
