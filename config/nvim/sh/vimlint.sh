#!/bin/sh
TEMP_FILE=$( mktemp -t "${0##*/}"-$$.XXXXXXXX )
vim -V1 -e -s -N -u NONE -i NONE -c "set rtp+=$1,$2" -c "call vimlint#vimlint('$3', { 'output': '$TEMP_FILE' })" -c "qall!" > /dev/null 2>&1
cat "$TEMP_FILE"
