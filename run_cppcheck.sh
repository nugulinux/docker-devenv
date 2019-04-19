#!/bin/sh

if [ "$#" -ne 1 ]; then
	echo "Illegal number of parameters"
	exit 1
fi

gerrit-check -t cppcheck -l --commit $1
