# -*- coding: utf-8 -*-
# vim:se fenc=utf-8 noet:
from __future__ import (unicode_literals, division, absolute_import, print_function)

import json
import os.path

from imaplib import IMAP4_SSL_PORT, IMAP4_SSL, IMAP4

from powerline.segments.common.mail import (EmailIMAPSegment, _IMAPKey)

class CustomEmailIMAPSegment(EmailIMAPSegment):
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

email_imap_alert = CustomEmailIMAPSegment()
