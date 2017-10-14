function! ale_linters#toml#tomlv#handle(buffer, lines) abort "{{{
  let pattern = '\vError in ''.+'': (.+)$'
  let output = []

  for line in a:lines
    let mt = matchlist(line, pattern)
    if len(mt) == 0
      continue
    endif

    let text = mt[1]
    let lnum_mt = matchlist(text, '\v^.+ line (\d+)')
    call add(output, {
          \   'lnum': len(lnum_mt) > 0 ? lnum_mt[1] + 0 : 1,
          \   'text': text,
          \ })
  endfor

  return output
endfunction "}}}

call ale#linter#Define('toml', {
      \   'name': 'tomlv',
      \   'executable': 'tomlv',
      \   'command':  'tomlv %s',
      \   'callback': 'ale_linters#toml#tomlv#handle',
      \   'output_stream': 'stderr',
      \   'lint_file': 1,
      \})

