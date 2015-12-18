# vim:fileencoding=utf-8:noet
from __future__ import (unicode_literals, division, absolute_import, print_function)

from powerline.theme import requires_segment_info
import powerline.segments.vim

@requires_segment_info
def mode(pl, segment_info, override=None):
	mode = segment_info['mode']
	if mode == 'nc':
		return 'INACTIVE'
	else:
		return powerline.segments.vim.mode(pl, segment_info, override)
