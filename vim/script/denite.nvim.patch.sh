#!/bin/sh

#=============================================================================
# Apply patch for file_old
#
# WARNING: Change current directory to 'denite.nvim' dir.
#

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [ "$CURRENT_BRANCH" != "master" -a "$CURRENT_BRANCH" != "patched" ]; then
  echo 'Current branch is not "master" or "patched". Aborted.'
  exit 1
fi
if [ "$CURRENT_BRANCH" = "patched" ] || git branch | grep -q patched; then
  # Already patched.
  exit 0
fi

# Check
PATCH_FILE=$HOME/.vim/patches/denite.nvim.patch
git apply --binary --check "$PATCH_FILE" >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Cannot apply patch [$PATCH_FILE]"
  exit 1
fi

# Create and checkout branch
git checkout -b patched master

# Apply patch
git apply --binary "$PATCH_FILE" >/dev/null \
  && git add -u . \
  && git commit -m 'Apply patch for python3.5'

# vim:set sw=2:
