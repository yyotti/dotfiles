# vim:se fenc=utf8 noet ts=8 sw=8 sts=8:
from __future__ import (unicode_literals, division, absolute_import, print_function)

from powerline.segments.vim import window_cached

try:
	import vim
except ImportError:
	vim = object()

@window_cached
def repos_dir(pl):
	dir = vim.eval('expand("%:p:h:h")')

	return [{
		'contents': dir,
		'highlight_groups': ['fugitive:repos_dir']
		}]
