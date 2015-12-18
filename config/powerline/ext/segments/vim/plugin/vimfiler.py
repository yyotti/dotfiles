# vim:se fenc=utf8 noet ts=8 sw=8 sts=8:
from __future__ import (unicode_literals, division, absolute_import, print_function)

from powerline.segments.vim import window_cached
from powerline.bindings.vim import vim_get_func

@window_cached
def status_string(pl):
	status_string = vim_get_func('vimfiler#get_status_string')()

	return [{
		'contents': status_string,
		'highlight_groups': ['vimfiler:status_string']
		}]
