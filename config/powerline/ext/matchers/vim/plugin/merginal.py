# vim:fileencoding=utf-8:noet
from __future__ import (unicode_literals, division, absolute_import, print_function)

import os

from powerline.bindings.vim import (vim_getbufoption, buffer_name)

def branch(matcher_info):
	return os.path.basename(buffer_name(matcher_info)) == 'Merginal:Branches'

def log(matcher_info):
	return os.path.basename(buffer_name(matcher_info)) == 'Merginal:HistoryLog'
