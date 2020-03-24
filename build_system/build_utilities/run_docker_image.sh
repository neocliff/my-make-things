#!/bin/bash

#SCRIPT_DIR=$(dirname "$0")
#pushd "$SCRIPT_DIR" > /dev/null
#BASE_DIR=$(readlink -f "${SCRIPT_DIR}")

#docker run --rm -it -v $BASE_DIR:/home/user/Documents/my-make-things toolset:latest bash my-make-things/build.sh

# format is:
#   docker run 
#       --rm        automatically delete the container when it exits
#       -i          run the container in interactive mode
#       -t          allocate a pseudo-tty for the console
#       -v          connect a volume using "source:destination" syntax
#           `git rev-parse --show-toplevel` is the root of the current repo (source)
#           /home/user/my-make-things is the mount point in the container (destination)
#       <image>     name of the container image in "image:tag" format
#       <cmd [opts]>
#                   name of the command to run in the container, usually a shell
#                   with optional parameters
docker run --rm -it -v `git rev-parse --show-toplevel`:/home/user/my-make-things toolset:latest /bin/bash