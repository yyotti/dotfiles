#!/usr/bin/env bash
set -eu

echo 'Install Node.js.'

echo '  Install Nodebrew.'
curl -L git.io/nodebrew | perl - setup

echo

echo '  Install Node.js (latest version).'
"${HOME}/.nodebrew/current/bin/nodebrew" install-binary latest
"${HOME}/.nodebrew/current/bin/nodebrew" use latest

echo '  Install yarn.'
npm install --global yarn

echo
