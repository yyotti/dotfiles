#!/bin/sh
echo 'install neobundle...'
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh

VIMPROC_DIR="$HOME/.vim/bundle/vimproc"
if [ -e "$VIMPROC_DIR" ]; then
  echo "$VIMPROC_DIR already exists!"
  exit 1
fi

echo 'install vimproc...'

# check git command
if type git; then
  : # You have git command. No Problem.
else
  echo 'Please install git or update your path to include the git executable!'
  exit 1;
fi

# make bundle dir and fetch neobundle
echo "Begin fetching vimproc..."
git clone https://github.com/Shougo/vimproc.vim.git "$VIMPROC_DIR"
echo "Done."

# compile vimproc
echo "Begin compiling vimproc..."
cd "$VIMPROC_DIR"
make
echo "Done."
