# -*- coding: utf-8 -*-
# vim:se fenc=utf8 noet ts=8 sw=8 sts=8:
from __future__ import (unicode_literals, division, absolute_import, print_function)

import re

from powerline.bindings.vim import (vim_func_exists, vim_get_func)

def eskk_status(pl):
	'''Show eskk status
	Highlight groups used ``eskk``
	'''

	if not vim_func_exists('eskk#statusline'):
		return []

	str = vim_get_func('eskk#statusline')()

	mode_str_regex = re.compile(r'^\[eskk:(.+)\]$')
	m = re.search(mode_str_regex, str)
	if not m:
		return []

	return [{
		'contents': m.group(1),
		'highlight_groups': ['eskk']
		}]
