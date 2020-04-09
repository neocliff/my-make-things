#!/bin/bash

PROJ_ROOT=`git rev-parse --show-toplevel`

if [ $# -gt 0 ]; then
    echo "usage: $0"
    echo "purpose:"
    echo "    runs the toolset container in interactive mode. it assumes the"
    echo "    script is run somewhere within a repository. the current working"
    echo "    directory is assumed to be the working directory within the"
    echo "    container when launched."
    exit 1
fi

echo "launching interactive toolchain container..."

# set the in-container working directory to be the current working directory.
# at first, i used the following line of commands to set the value and then
# it hit me that i could just make WORKING_dir the same at the PWD because
# it is going to be that in the container. duh!
#working_dir=$(echo `pwd` | sed "s,`git rev-parse --show-toplevel`/,,")
WORKING_DIR=`pwd`

# everything else in the arguments from the cli is to be passed into the container
# as the command to be run. this code will work because there is at least one
# argument left or we wouldn't have gotten this far.
#command_to_run="$(printf "${1+ %q}" "$@")"

# format of 'docker run' command is:
#   docker run
#       --rm        automatically delete the container when it exits
#       -i          run the container in interactive mode
#       -t          allocate a pseudo-tty for the console
#       -v          connect a volume using "source:destination[:ro]" syntax
#           `git rev-parse --show-toplevel` is the root of the current repo (source)
#                   and is the mount point in the container (destination)
#           the "ro" indicates a mount is to be read-only within the container
#       <image>     name of the container image in "image:tag" format

echo "PROJ_ROOT is   $PROJ_ROOT"
echo "working_dir is $WORKING_DIR"

docker run --rm -it -v $PROJ_ROOT:$PROJ_ROOT \
        --workdir $WORKING_DIR toolset:latest
