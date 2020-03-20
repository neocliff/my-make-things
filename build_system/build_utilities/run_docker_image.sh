#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
pushd "$SCRIPT_DIR" > /dev/null
BASE_DIR=$(readlink -f "${SCRIPT_DIR}")

docker run --rm -it -v $BASE_DIR:/home/user/Documents/my-make-things user:dev bash my-make-things/build.sh
