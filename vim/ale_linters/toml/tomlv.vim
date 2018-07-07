function! ale_linters#toml#tomlv#handle(...) abort "{{{
  let l:lines = a:0 > 1 ? a:2 : []
  let l:pattern = '\vError in ''.+'': (.+)$'
  let l:output = []

  for l:line in l:lines
    let l:mt = matchlist(l:line, l:pattern)
    if len(l:mt) == 0
      continue
    endif

    let l:text = l:mt[1]
    let l:lnum_mt = matchlist(l:text, '\v^.+ line (\d+)')
    call add(l:output, {
          \   'lnum': len(l:lnum_mt) > 0 ? l:lnum_mt[1] + 0 : 1,
          \   'text': l:text,
          \ })
  endfor

  return l:output
endfunction "}}}

call ale#linter#Define('toml', {
      \   'name': 'tomlv',
      \   'executable': 'tomlv',
      \   'command':  'tomlv %s',
      \   'callback': 'ale_linters#toml#tomlv#handle',
      \   'output_stream': 'stderr',
      \   'lint_file': 1,
      \})

