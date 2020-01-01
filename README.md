# my-make-things

this repo contains a complete make system that (hopefully) 
scales-up to support building a complex project. this code
uses maxtrua's Makefile project for handling dependency
files (generation and loading).

how the make system is laid out...
* hello/makefile - the main driver for everything
* hello/component.mk - defines the component being built
* build_system/build_library/defaults.mk - contains the default 
definitions of tools, etc used in this project
* build_system/build_library/compiler_rules.mk - define's the 
default recipes to comile, etc