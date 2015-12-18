# vim:fileencoding=utf-8:noet
from __future__ import (unicode_literals, division, absolute_import, print_function)

from powerline.bindings.vim import vim_getbufoption

def gitcommit(matcher_info):
	return vim_getbufoption(matcher_info, 'filetype') == 'gitcommit'
