# vim:fileencoding=utf-8:noet
from __future__ import (unicode_literals, division, absolute_import, print_function)

import os

from powerline.bindings.vim import (vim_getbufoption, buffer_name)

def merginal(matcher_info):
	name = os.path.basename(buffer_name(matcher_info))
	return len(name) > 8 and name[0:9]  == 'Merginal:'
