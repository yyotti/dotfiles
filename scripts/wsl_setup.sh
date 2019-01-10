#!/usr/bin/env bash

set -eu

# Initialize for `sudo` {{{
sudo -k
trap 'sudo -k' EXIT
# }}}

# XDG Base Directory {{{
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-${HOME}/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-${HOME}/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-${HOME}/.local/share}
# }}}

# Update pre-installed packages {{{

# Replace source url
apt_src=/etc/apt/sources.list
tmp_src=$(mktemp)
sed -e 's%archive.ubuntu.com%ubuntutym.u-toyama.ac.jp%g' <"${apt_src}" \
  | tee >(sed -e 's%deb %deb-src %g') \
  | cat >"${tmp_src}"
if [[ ! -e ${apt_src}.org ]]; then
  sudo cp "${apt_src}" "${apt_src}.org"
fi
sudo mv -f "${tmp_src}" "${apt_src}"

# Update packages
sudo apt -y update
sudo apt -y upgrade
sudo apt -y autoremove

# }}}

# Install some common packages {{{
sudo apt -y install \
  build-essential \
  jq \
  language-pack-ja \
  manpages-ja \
  nkf \
  xsel

# }}}

# Install Git {{{
echo 'Install latest Git.'
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt -y install git

echo
# }}}

# Install dotfiles {{{
echo 'Clone dotfiles repo.'
export DOTFILES=${XDG_DATA_HOME}/dotfiles
git clone git@github.com:yyotti/dotfiles.git "${DOTFILES}"
find "${DOTFILES}/scripts/git" -type d -exec chmod 755 {} \;

echo '  Install dotfiles'
bash "${DOTFILES}/scripts/dotinstall.sh" -v install

echo
# }}}

# Install {{{
# bash "${DOTFILES}/scripts/install/tmpreaper.sh"

bash "${DOTFILES}/scripts/install/zsh.sh"

bash "${DOTFILES}/scripts/install/php.sh"

bash "${DOTFILES}/scripts/install/python.sh"

export GOPATH=${XDG_DATA_HOME}/go
bash "${DOTFILES}/scripts/install/golang.sh"
export PATH=${GOPATH}/bin:/usr/local/go/bin:${PATH}

bash "${DOTFILES}/scripts/install/ghq.sh"

bash "${DOTFILES}/scripts/install/tmux.sh"

bash "${DOTFILES}/scripts/install/git-tools.sh"

bash "${DOTFILES}/scripts/install/node.sh"
export PATH=${HOME}/.nodebrew/current/bin:${PATH}

bash "${DOTFILES}/scripts/install/cli-tools.sh"

bash "${DOTFILES}/scripts/install/neovim.sh"
# }}}

echo "Setup finished."
echo "Rem: Change login shell! (run \`chsh -s \"\$(which zsh)\"\`)"
echo "Rem: Configure gist! (run \`gist config\`)"
