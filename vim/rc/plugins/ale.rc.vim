nmap <silent> [e <Plug>(ale_previous)
nmap <silent> [E <Plug>(ale_first)
nmap <silent> ]e <Plug>(ale_next)
nmap <silent> ]E <Plug>(ale_last)

" Vimscript
if !executable('vimlparser')
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
else
  function! HandleVimlparser(buffer, lines) abort "{{{
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
        \   'callback': 'HandleVimlparser',
        \   'output_stream': 'stderr',
        \})

endif

if executable('tomlv')
  function! HandleTomlv(buffer, lines) abort "{{{
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
        \   'callback': 'HandleTomlv',
        \   'output_stream': 'stderr',
        \   'lint_file': 1,
        \})
endif
