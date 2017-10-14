function! ale_linters#vim#vimlparser#handle(buffer, lines) abort "{{{
  let pattern = '\vvimlparser: (.+): line (\d+) col (\d+)$'
  let output = []

  for line in a:lines
    let mt = matchlist(line, pattern)
    if len(mt) == 0
      continue
    endif

    let text = mt[1]

    call add(output, {
          \   'lnum': mt[2] + 0,
          \   'col': mt[3] + 0,
          \   'text': text,
          \   'type': text =~# '^E' ? 'E' : 'W',
          \ })
  endfor

  return output
endfunction "}}}

call ale#linter#Define('vim', {
      \   'name': 'vimlparser',
      \   'executable': 'vimlparser',
      \   'command':  'vimlparser' . (has('nvim') ? ' -neovim' : ''),
      \   'callback': 'ale_linters#vim#vimlparser#handle',
      \   'output_stream': 'stderr',
      \})

if !IsWindows()
  " TODO
  " let g:neomake_vim_enabled_makers = [ 'vimlint' ]
  " let g:neomake_vim_vimlint_maker = {
  "       \   'exe': expand('~/.vim/script/vimlint.sh'),
  "       \   'args': [ '-u' ],
  "       \   'errorformat':
  "       \     '%f:%l:%c:%trror: %m,%f:%l:%c:%tarning: %m,%f:%l:%c:%m',
  "       \ }
endif

