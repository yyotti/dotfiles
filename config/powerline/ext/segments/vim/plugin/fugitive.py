# -*- coding: utf-8 -*-
# vim:se fenc=utf8 noet ts=8 sw=8 sts=8:
from __future__ import (unicode_literals, division, absolute_import, print_function)

import re

from powerline.theme import requires_segment_info
from powerline.segments.vim import (window_cached, buffer_name)

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

FUGITIVE_RE = re.compile(b'^.+\.git//([0-9a-f]+)/(.+)/([^/]+)$')

@requires_segment_info
def revision(pl, segment_info, length=0):
	name = buffer_name(segment_info)
	if not name:
		return []

	match = FUGITIVE_RE.match(name)
	if not match:
		return []

	rev = match.group(1).decode(segment_info['encoding'], 'powerline_vim_strtrans_error')
	if rev == '0': # TODO 0なら本当にHEADか？3-wayマージのときは1とか2とかある気がするが・・・
		rev = 'HEAD'
	elif length > 0 and len(rev) > length:
		rev = rev[0:length - 1]

	return [{
		'contents': rev,
		'highlight_groups': ['fugitive:revision']
		}]

@requires_segment_info
def file_directory(pl, segment_info):
	name = buffer_name(segment_info)
	if not name:
		return []

	match = FUGITIVE_RE.match(name)
	if not match:
		return []

	directory = match.group(2).decode(segment_info['encoding'], 'powerline_vim_strtrans_error')
	return [{
		'contents': directory + '/',
		'highlight_groups': ['fugitive:file_directory']
		}]
