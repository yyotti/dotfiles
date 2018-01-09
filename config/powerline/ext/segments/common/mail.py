from __future__ import unicode_literals
from __future__ import division
from __future__ import absolute_import
from __future__ import print_function

import json
import os.path

from imaplib import IMAP4_SSL_PORT

from powerline.segments.common.mail import _IMAPKey
from powerline.segments.common.mail import EmailIMAPSegment


class CustomEmailIMAPSegment(EmailIMAPSegment):
    @staticmethod
    def key(config_file=None, server='imap.gmail.com', port=IMAP4_SSL_PORT,
            folder='INBOX', use_ssl=None, **kwargs):
        if config_file is None:
            config_file = 'mail_config.json'

        config_file = os.path.expanduser(config_file)
        if not os.path.isabs(config_file):
            config_home = os.environ['XDG_CONFIG_HOME']
            if config_home == '':
                config_home = os.path.join(os.environ['HOME'], '.config')
            config_file = os.path.abspath(os.path.join(config_home,
                                                       'powerline',
                                                       config_file))

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
