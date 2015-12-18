# -*- coding: utf-8 -*-
# vim:se fenc=utf8 noet ts=8 sw=8 sts=8:
from __future__ import (unicode_literals, division, absolute_import, print_function)

from powerline.segments.vim import window_cached
from powerline.bindings.vim import vim_get_func
from powerline.theme import requires_segment_info

@window_cached
@requires_segment_info
def status_string(pl, segment_info):
	status_string = vim_get_func('unite#get_status_string')()
	if len(status_string) > 0:
		status_string = status_string.decode(segment_info['encoding'], 'powerline_vim_strtrans_error').split(" |")[0]

	return [{
		'contents': status_string,
		'highlight_groups': ['unite:status_string']
		}]
