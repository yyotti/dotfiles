#!/bin/sh
##
## Run git-diff(1) and convert into normal diff format for vimdiff(1)
## Copyright (c) 2014 SATOH Fumiyasu @ OSS Technology Corp., Japan
##	<https://github.com/fumiyas/home-commands/blob/master/git-diff-normal>
##	<https://fumiyas.github.io/>
##
## License: Do What The Fuck You Want To Public License (WTFPL) version 2
##
## Inspired by:
##   * vimdiffでより賢いアルゴリズム (patience, histogram) を使う - Qiita
##     * http://qiita.com/takaakikasai/items/3d4f8a4867364a46dfa3
##
## Example:
##	$ git-diff-normal --vimrc >>~/.vimrc
##	$ vimdiff foobar.txt.old foobar.txt
##

set -u
[ -n "${BASH_VERSION-}" ] && [ "${BASH_VERSION%%.*}" -ge 3 ] && set -o pipefail
[ -n "${ZSH_VERSION-}" ] && [ "${ZSH_VERSION%%.*}" -ge 5 ] && set -o pipefail

git="${GIT:-git}"

## Check if git(1) is available or not
if [ $# -eq 0 ]; then
  type "$git" >/dev/null 2>&1
  exit $?
fi

## Output sample .vimrc
if [ X"$1" == X"--vimrc" ]; then
  sed -n "/<<'VIMRC_EOF'$/,/^VIMRC_EOF$/p" "$0" |sed '1d;$d'
  exit 0
fi

## Do git-diff(1) and convert into normal diff format for vimdiff(1)
"$git" diff \
  --unified=0 \
  --no-ext-diff \
  --no-index \
  --no-color \
  "$@" \
|sed \
  -e '1,/^+++/d' \
  -e 's/^@@ -\([0-9]*\),*\([^ ]*\) +\([0-9]*\),*\([^ ]*\).*/\1,\2,\3,\4/' \
  -e 's/^-/< /' \
  -e 's/^+/> /' \
|awk -F, \
  '
    /^>/ && d \
      { print "---" }
    /^</ \
      { d = 1 }
    /^[^<]/ \
      { d = 0 }
    /^[0-9]/ {
      s = $1
      if ($2 > 0) {
	s = s "," ($1 + $2 - 1)
      }
      if (match($2, /^0$/)) {
	s = s "a"
      } else if (match($4, /^0$/)) {
	s = s "d"
      } else {
	s = s "c"
      }
      s = s $3
      if ($4 > 0) {
	s = s "," ($3 + $4 - 1)
      }
      $0 = s
    }
    { print }
  ' \
;

exit 0

: <<'VIMRC_EOF'
let g:git_diff_normal="git-diff-normal"
let g:git_diff_normal_opts=["--diff-algorithm=histogram"]

function! GitDiffNormal()
  let args=[g:git_diff_normal]
  if &diffopt =~ "iwhite"
    call add(args, "--ignore-all-space")
  endif
  call extend(args, g:git_diff_normal_opts)
  call extend(args, [v:fname_in, v:fname_new])
  let cmd="!" . join(args, " ") . ">" . v:fname_out
  silent execute cmd
  redraw!
endfunction

if executable(g:git_diff_normal)
  call system(g:git_diff_normal)
  if v:shell_error == 0
    set diffexpr=GitDiffNormal()
  endif
endif
VIMRC_EOF

