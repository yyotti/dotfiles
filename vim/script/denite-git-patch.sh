#!/bin/sh

#=============================================================================
# Apply patch for python3.5
#
# WARNING: Change current directory to 'denite-git' dir.
#

CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`
if [ "$CURRENT_BRANCH" != "master" -a "$CURRENT_BRANCH" != "patched" ]; then
  echo 'Current branch is not "master" or "patched". Aborted.'
  exit 1
fi
if [ "$CURRENT_BRANCH" = "patched" -o -n "`git branch | grep patched`" ]; then
  # Already patched
  exit 0
fi

PYCMD=`which python3`
if [ -z "$PYCMD" ]; then
  PYCMD=`which python`
  if [ -z "$PYCMD" ]; then
    exit 1
  fi
fi

PYVER=`"$PYCMD" --version 2>&1 | sed 's/.*\([0-9]\+\.[0-9]\+\)\.[0-9]\+/\1/'`
if [ `echo "$PYVER > 3.5" | bc` -eq 1 ]; then
  exit 0
fi

# Check
PATCH_FILE=$HOME/.vim/patches/denite-git.patch
git apply --binary --check "$PATCH_FILE" >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Cannot apply patch [$PATCH_FILE]"
  exit 1
fi

# Create and checkout branch
git checkout -b patched master

# Apply patch
git apply --binary "$PATCH_FILE" >/dev/null
git add .
git commit -m 'Apply patch for python3.5'

# vim:set sw=2:
