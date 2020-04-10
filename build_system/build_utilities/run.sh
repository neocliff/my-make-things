#!/bin/sh

# this script is used to run a single command in the toolset container.
# the script mounts the root of the repo as a volume in the container and
# sets the working directory in the container to the same directory the script
# is launched from. anything after the script name becomes the arguments passed
# into the container.

PROJ_ROOT=`git rev-parse --show-toplevel`
WORKING_DIR=`pwd`

if [ $# -lt 1 ]; then
    echo "usage: $0 <command-and-args>"
    echo "where:"
    echo "  <command-and-args> is the command to run"
    exit 1
fi

# everything in the arguments from the cli is to be passed into the container
# as the command to be run. this code will work because there is at least one
# argument left or we wouldn't have gotten this far.
#COMMAND_TO_RUN="$(printf "${1+ %q}" "$@")"
COMMAND_TO_RUN="$@"

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
#       <cmd [opts]>
#                   name of the command to run in the container, usually a shell
#                   with optional parameters

echo "PROJ_ROOT is      $PROJ_ROOT"
echo "WORKING_DIR is    $WORKING_DIR"
echo "COMMAND_TO_RUN is $COMMAND_TO_RUN"
echo ""

docker run --rm -it -v $PROJ_ROOT:$PROJ_ROOT \
        --workdir $WORKING_DIR toolset:latest $COMMAND_TO_RUN
