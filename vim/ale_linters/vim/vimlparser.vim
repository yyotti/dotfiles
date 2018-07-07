function! ale_linters#vim#vimlparser#handle(...) abort "{{{
  let l:lines = a:0 > 1 ? a:2 : []
  let l:pattern = '\vvimlparser: (.+): line (\d+) col (\d+)$'
  let l:output = []

  for l:line in l:lines
    let l:mt = matchlist(l:line, l:pattern)
    if len(l:mt) == 0
      continue
    endif

    let l:text = l:mt[1]

    call add(l:output, {
          \   'lnum': l:mt[2] + 0,
          \   'col': l:mt[3] + 0,
          \   'text': l:text,
          \   'type': l:text =~# '^E' ? 'E' : 'W',
          \ })
  endfor

  return l:output
endfunction "}}}

call ale#linter#Define('vim', {
      \   'name': 'vimlparser',
      \   'executable': 'vimlparser',
      \   'command':  'vimlparser' . (has('nvim') ? ' -neovim' : ''),
      \   'callback': 'ale_linters#vim#vimlparser#handle',
      \   'output_stream': 'stderr',
      \})
