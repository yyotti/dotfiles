#!/usr/bin/env bash
set -eu

echo 'Install tmpreaper.'
sudo apt -y install tmpreaper

echo '  Edit /etc/tmpreaper.conf'
conf_src=/etc/tmpreaper.conf
tmp_src=$(mktemp)
sed -e 's/^\s*SHOWWARNING=true/# \0/' <"${conf_src}" \
  | sed -e "s/^\s*TMPREAPER_DELAY='.*'/TMPREAPER_DELAY='0'/" \
  | cat >"${tmp_src}"
if [[ ! -e ${conf_src}.org ]]; then
  sudo cp "${conf_src}" "${conf_src}.org"
fi
sudo mv -f "${tmp_src}" "${conf_src}"

sudo /etc/cron.daily/tmpreaper

echo
