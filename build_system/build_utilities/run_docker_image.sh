#!/bin/bash

# for historical purposes...
#   docker run --rm -it -v $BASE_DIR:/home/user/Documents/my-make-things \
#       toolset:latest bash my-make-things/build.sh

PROJ_ROOT=`git rev-parse --show-toplevel`

if [ $# -lt 2 ]; then
    echo "usage: $0 <dir> <command-and-args>"
    echo "where:"
    echo "  <dir> is the working directory relative to $PROJ_ROOT"
    echo "  <command-and-args> is the command to run"
    exit 1
fi

# pull off the in-container working directory and then shift the arguments.
# note that this working directory is relative to the root of the repository,
# e.g., if my repo is at /home/user/Documents/my-make-things, and i use the
# path src/hello, the working directory within the container will be set to
# /home/user/Documents/my-make-things/src/hello. the command string passed
# into the container to be run will do so in the working container.
working_dir=$1
shift

# everything else in the arguments from the cli is to be passed into the container
# as the command to be run. this code will work because there is at least one
# argument left or we wouldn't have gotten this far.
command_to_run="$(printf "${1+ %q}" "$@")"

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
echo "working_dir is    $working_dir"
echo "command_to_run is $command_to_run"

docker run --rm -it -v $PROJ_ROOT:$PROJ_ROOT \
        --workdir $PROJ_ROOT/$working_dir toolset:latest $command_to_run
