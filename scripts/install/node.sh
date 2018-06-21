#!/usr/bin/env bash
set -eu

echo 'Install Node.js.'

echo '  Install Nodebrew.'
curl -L git.io/nodebrew | perl - setup

echo

echo '  Install Node.js (latest version).'
nodebrew install-binary latest && nodebrew use latest

echo
