# my-make-things

This repo contains a complete make system that (hopefully)
scales-up to support building a complex project. This code
started with maxtrua's Makefile project for handling dependency
files (generation and loading) and grew from there. I built this
as a skeleton for a large project at work.

At first glance, it will seem like there is an over-abundance of
comments in the code files. This is intentional on my part for
two reasons. First, people are so used to reading things on the
web, anything that's not a two sentence paragraph or a bulleted
list is ignored.

The second reason is I don't believe in self-documenting
code. It's like unicorns: we may dream of them but they don't
exist. After more than 35 years of writing code, I've seen
a *lot* of code. Much of it the author claimed was self-commenting.
Yet, if you took the self-documenting code back to the author a
few weeks or months later, they had to spend a fair amount of time
studying it to figure out what it did.

Bottom line: if the comments are in the way, feel free to delete
them.

## Organization of Make Files

How the make system is laid out. First the build system files...

* build_system/build_library/makefile - this the main driver for
all components is the same across the project; tailoring happens
in the component.mk file for each component
* build_system/build_library/defaults.mk - contains the default
definitions of tools, etc used in this project
* build_system/build_library/compiler_rules.mk - define's the
default recipes to comile, etc

Now files for individual components that we are building for...

* hello/component.mk - tailors the program to be built; gets
functionality from a_dir object files
* a_dir/component.mk - tailors the make system for this component

## make Targets

A standard set of targets are defined in the makefile. Use
these target to build, etc.

* all - this is the default target and it directs make to build
everything; defined in component.mk
* clean - use this target  clean-up flotsam from a prior build
but leave some things as they are, e.g., the dependency files;
defined in makefile
* cleanall - use this target to clean-up everything that was
generated by a prior build; defined in makefile
* checkit - outputs the configuration of the make system for
this component; defined in makefile
