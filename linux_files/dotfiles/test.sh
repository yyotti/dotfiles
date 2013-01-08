#!/bin/sh
readonly BASE_DIR=$(cd $(dirname $0) && pwd)

readonly TARGET_DIR=~
for file in `ls -a`
do
  if expr "$file" : "^\.[^.]\+$" > /dev/null ; then
		  if [ ! -e $TARGET_DIR/$file ]; then
    	echo "ない"
    fi
  fi
done
