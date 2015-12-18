# -*- coding: utf-8 -*-
# vim:se fenc=utf8 noet ts=8 sw=8 sts=8:
from __future__ import (unicode_literals, division, absolute_import, print_function)

import re

from powerline.bindings.vim import (vim_func_exists, vim_global_exists, vim_get_func, vim_getvar)

def hunks(pl, sign_added='A', sign_modified='M', sign_deleted='D', sign_sep=' ', sign_subsep=' '):
	if not vim_func_exists('GitGutterGetHunkSummary'):
		return []

	if vim_global_exists('gitgutter_enabled') and not vim_getvar('gitgutter_enabled'):
		return []

	signs = []
	if sign_added == '':
		signs.append('A')
	else:
		signs.append(sign_added)
	if sign_modified == '':
		signs.append('M')
	else:
		signs.append(sign_modified)
	if sign_deleted == '':
		signs.append('D')
	else:
		signs.append(sign_deleted)

	hunks = vim_get_func('GitGutterGetHunkSummary')()

	ret = []
	for (count, sign) in zip(hunks, signs):
		if count > 0:
			ret.append(sign + sign_subsep + str(count))

	return [] if len(ret) == 0 else [{
		'contents': sign_sep.join(ret),
		'highlight_groups': ['gitgutter_hunks']
		}]
