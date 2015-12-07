# -*- coding: utf-8 -*-
# vim:se fenc=utf8 noet ts=8 sw=8 sts=8:
from __future__ import (unicode_literals, division, absolute_import, print_function)

try:
	import vim
except ImportError:
	vim = object()

from powerline.bindings.vim import vim_get_func

def eskk_status(pl):
	'''Show eskk status
	Highlight groups used ``eskk``
	'''

	str = vim_get_func('Eskk')()

	return [] if str == u'' else [{
		'contents': str,
		'highlight_groups': ['eskk']
		}]
