#!/bin/sh

##
# @file post_build_strip.sh
# @brief strips the name binary
# @author Cliff Williams
#
# This script demonstrates a post-build step, stripping a binary
# of symbols and other debug information to produce a final, release
# binary file.

# verify parameters
if [ "$#" -ne "1" ]; then
    echo "usage: $0 bin-file"
    echo "where:"
    echo "  bin-file - binary file to be stripped"
    exit 1
fi

if [ ! -x $1 ]; then
    echo "error: file does not exist: $1"
    exit 2
fi

echo "stripping binary: $1"
/usr/bin/strip $1

# finished. return to caller
echo "done!"
exit 0
