#!/bin/bash

echo $PWD
cd my-make-things/src/hello
echo $PWD

make BUILD_TYPE=release ARCH_TYPE=x86_32 -f ../../build_system/build_library/makefile
