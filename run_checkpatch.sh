#!/bin/sh

if [ "$#" -ne 1 ]; then
	echo "Illegal number of parameters"
	exit 1
fi

git show --format=email $1 | \
	checkpatch.pl -q --no-tree - | \
	checkpatch-to-gerrit-json.py
