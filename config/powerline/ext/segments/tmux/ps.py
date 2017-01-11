# -*- coding: utf-8 -*-
# vim:se fenc=utf-8 noet:

from __future__ import (unicode_literals, division, absolute_import, print_function)

# import commands
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

#'''Return used memory.
#
#Requires the ``psutil`` module.
#
#:param str format:
#	Output format. Accepts measured used memory as the first argument.
#:param str unit:
#	Output unit (Accepts "MB" or "KB"). Default is "MB"
#
#Highlight groups used: ``used_memory``.
#'''
def used_memory(pl, format='{0:.0f}', unit='MB'):
	try:
		total = psutil.virtual_memory().total
		available = psutil.virtual_memory().available
	except:
		total = psutil.phymem_usage().total
		available = psutil.phymem_usage().available

	memory = total - available
	if unit == 'MB':
		memory = memory / (1024.0 * 1024)
	elif unit == 'KB':
		memory = memory / (1024.0)

	return [{
		'contents': format.format(memory),
		'gradient_level': memory,
		'highlight_groups': ['used_memory'],
		}]

#'''Return total memory.
#
#Requires the ``psutil`` module.
#
#:param str format:
#	Output format. Accepts measured used memory as the first argument.
#:param str unit:
#	Output unit (Accepts "MB" or "KB"). Default is "MB"
#
#Highlight groups used: ``total_memory``.
#'''
def total_memory(pl, format='{0:.0f}', unit='MB'):
	try:
		memory = psutil.virtual_memory().total
	except:
		memory = psutil.phymem_usage().total

	if unit == 'MB':
		memory = memory / (1024.0 * 1024)
	elif unit == 'KB':
		memory = memory / (1024.0)

	return [{
		'contents': format.format(memory),
		'gradient_level': memory,
		'highlight_groups': ['total_memory'],
		}]
