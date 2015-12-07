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

class UsedMemoryPercentSegment(ThreadedSegment):
	interval = 1

	def active_memory_percent(self):
		try:
			return psutil.virtual_memory().percent
		except:
			return psutil.phymem_usage().percent

	def update(self, old_used_memory):
		return self.active_memory_percent()

	def run(self):
		while not self.shutdown_event.is_set():
			try:
				self.update_value = self.active_memory_percent()
			except Exception as e:
				self.exception('Exception whilte calculating used_memory_percent: {0}', str(e))

	def render(self, used_memory_percent, format='{0:.0f}%', **kwargs):
		if not used_memory_percent:
			return None
		return [{
			'contents': format.format(used_memory_percent),
			'gradient_level': used_memory_percent,
			'highlight_groups': ['used_memory_percent_gradient', 'used_memory_percent']
			}]

#used_memory_percent = with_docstring(UsedMemoryPercentSegment(),
#'''Return used memory as a percentage.
#
#Requires the ``psutil`` module.
#
#:param str format:
#	Output format. Accepts measured used memory as the first argument.
#
#Highlight groups used: ``used_memory_percent_gradient`` (gradient) or ``used_memory_percent``.
#''')

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
