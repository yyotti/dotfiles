#!/bin/sh
VIML_PARSER=$1
VIM_VIMLINT=$2
OUTPUT=$3
if [ ! -n "$VIM_PATH" ]; then
    VIM_PATH=vim
fi

trap "rm -f $OUTPUT" EXIT
$VIM_PATH -V1 -X -N -u NONE -i NONE -e -s \
  -c "set rtp+=$VIML_PARSER,$VIM_VIMLINT" \
  -c "call vimlint#vimlint('$4', { 'quiet': 1, 'output': '$OUTPUT' })" \
  -c "qall!"
RET=$?

cat $OUTPUT

exit $RET

# vim:set sw=2:
