# vim:fileencoding=utf-8:noet
from __future__ import (unicode_literals, division, absolute_import, print_function)

import re

from powerline.bindings.vim import (vim_getbufoption, buffer_name)

def gitcommit(matcher_info):
	return vim_getbufoption(matcher_info, 'filetype') == 'gitcommit'

SCHEME_RE = re.compile(b'^\\w[\\w\\d+\\-.]*(?=:)')
def revision(matcher_info):
	name = buffer_name(matcher_info)
	if not name:
		return False

	scheme = None
	match = SCHEME_RE.match(name)
	if match:
		scheme = match.group(0).decode('ascii')

	return scheme and scheme == 'fugitive'
