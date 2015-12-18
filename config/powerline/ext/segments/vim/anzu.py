# -*- coding: utf-8 -*-
# vim:se fenc=utf8 noet ts=8 sw=8 sts=8:
from __future__ import (unicode_literals, division, absolute_import, print_function)

try:
	import vim
except ImportError:
	vim = object()

import re

from powerline.bindings.vim import (vim_func_exists, vim_get_func)

def search_status(pl):
	if not vim_func_exists('anzu#search_status'):
		return []

	status = vim_get_func('anzu#search_status')()
	if status == u'':
		return []

	return [] if len(status) == 0 else [{
		'contents': status,
		'highlight_groups': ['anzu_search_status']
		}]
