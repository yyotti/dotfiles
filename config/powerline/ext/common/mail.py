# -*- coding: utf-8 -*-
# vim:se fenc=utf-8 noet:
from __future__ import (unicode_literals, division, absolute_import, print_function)

import re
import json
import os.path

from imaplib import IMAP4_SSL_PORT, IMAP4_SSL, IMAP4
from collections import namedtuple

from powerline.lib.threaded import KwThreadedSegment
from powerline.segments import with_docstring


_IMAPKey = namedtuple('Key', 'username password server port folder use_ssl')


class EmailIMAPSegment(KwThreadedSegment):
	interval = 60

	@staticmethod
	def key(config_file=None, server='imap.gmail.com', port=IMAP4_SSL_PORT, folder='INBOX', use_ssl=None, **kwargs):
		if config_file is None:
			config_file = 'mail_config.json'

		config_file = os.path.expanduser(config_file)
		if not os.path.isabs(config_file):
			config_file = os.path.abspath(os.path.expanduser('~/.config/powerline/' + config_file)) # TODO powerlineのユーザ設定ディレクトリを取得する

		if not os.path.isfile(config_file):
			username = ''
			password = ''
		else:
			f = open(config_file)
			data = json.load(f)
			f.close

			username = data['username']
			password = data['password']

		if use_ssl is None:
			use_ssl = (port == IMAP4_SSL_PORT)

		return _IMAPKey(username, password, server, port, folder, use_ssl)

	def compute_state(self, key):
		if not key.username or not key.password:
			self.warn('Username and password are not configured')
			return None
		if key.use_ssl:
			mail = IMAP4_SSL(key.server, key.port)
		else:
			mail = IMAP4(key.server, key.port)
		mail.login(key.username, key.password)
		rc, message = mail.status(key.folder, '(UNSEEN)')
		unread_str = message[0].decode('utf-8')
		unread_count = int(re.search('UNSEEN (\d+)', unread_str).group(1))
		return unread_count

	@staticmethod
	def render_one(unread_count, max_msgs=None, **kwargs):
		if not unread_count:
			return None
		elif type(unread_count) != int or not max_msgs:
			return [{
				'contents': str(unread_count),
				'highlight_groups': ['email_alert'],
			}]
		else:
			return [{
				'contents': str(unread_count),
				'highlight_groups': ['email_alert_gradient', 'email_alert'],
				'gradient_level': min(unread_count * 100.0 / max_msgs, 100),
			}]


email_imap_alert = with_docstring(EmailIMAPSegment(),
('''Return unread e-mail count for IMAP servers.

:param str config_file:
	config file path
:param str server:
	e-mail server
:param int port:
	e-mail server port
:param str folder:
	folder to check for e-mails
:param int max_msgs:
	Maximum number of messages. If there are more messages then max_msgs then it
	will use gradient level equal to 100, otherwise gradient level is equal to
	``100 * msgs_num / max_msgs``. If not present gradient is not computed.
:param bool use_ssl:
	If ``True`` then use SSL connection. If ``False`` then do not use it.
	Default is ``True`` if port is equal to {ssl_port} and ``False`` otherwise.

Highlight groups used: ``email_alert_gradient`` (gradient), ``email_alert``.
''').format(ssl_port=IMAP4_SSL_PORT))

