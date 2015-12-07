# -*- coding: utf-8 -*-
# vim:se fenc=utf-8 noet:

from __future__ import (unicode_literals, division, absolute_import, print_function)

import commands
import multiprocessing
import psutil
import re
import socket

from powerline.lib import add_divider_highlight_group
from powerline.lib.threaded import ThreadedSegment
from powerline.segments import with_docstring

#'''Return used memory as a percentage.
#
#Requires the ``psutil`` module.
#
#:param str format:
#	Output format. Accepts measured used memory as the first argument.
#
#Highlight groups used: ``used_memory_percent_gradient`` (gradient) or ``used_memory_percent``.
#'''
def used_memory_percent(pl, format='{0:.0f}%'):
	try:
		memory = psutil.virtual_memory().percent
	except:
		memory = psutil.phymem_usage().percent

	return [{
		'contents': format.format(memory),
		'gradient_level': memory,
		'highlight_groups': ['used_memory_percent_gradient', 'used_memory_percent'],
		}]
