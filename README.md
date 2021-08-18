# my-make-things

## Introduction

This repo contains a complete make system that (hopefully)
scales-up to support building a complex project. This code
started with maxtrua's Makefile project for handling dependency
files (generation and loading) and grew from there. I built this
as a skeleton for a large project at work.

At first glance, it will seem like there is an over-abundance of
comments in the code files. This is intentional on my part for
two reasons. First, people are so used to reading things on the
web, anything that's not a two sentence paragraph or a bulleted
list is ignored.  The second reason is a bit more controversial.

I don't believe in self-documenting code. It's like unicorns: we may
dream of them but they don't exist. After more than 35 years of
writing code, I've seen a *lot* of code. Much of it the author
claimed was "self-documenting".  Yet, if you took it back to the
author a few weeks or months later, they had to spend a fair amount
of time studying it to figure out what it did.

If the comments are in the way, feel free to delete them. You won't
hurt my feelings.

## Organization of Make Files

How the make system is laid out. First the build system files...

* [build_system/build_library/makefile](https://github.com/neocliff/my-make-things/blob/master/build_system/build_library/makefile) -
this the main driver for
all components is the same across the project; tailoring happens
in the component.mk file for each component
* [build_system/build_library/defaults.mk](https://github.com/neocliff/my-make-things/blob/master/build_system/build_library/defaults.mk) -
contains the default definitions of tools, etc used in this project
* [build_system/build_library/compiler_rules.mk](https://github.com/neocliff/my-make-things/blob/master/build_system/build_library/compiler_rules.mk) - define's the
default recipes to comile, etc
* [build_system/build_utilities/post_build_strip.sh](https://github.com/neocliff/my-make-things/blob/master/build_system/build_utilities/post_build_strip.sh) -
a toy script that accepts a single parameter, a binary, and strips the symbols,
debug information, etc. using /usr/bin/strip

Now files for individual components that we are building...

* hello/component.mk - tailors the program to be built; gets
functionality from a_dir object files
* a_dir/component.mk - tailors the make system for this component;
this component has two functions (as object files) used by hello.c's
main()
* b_dir/component.mk - tailors the make system for this component;
this component has two functions used by hello.c's main(); the
difference is these functions are in object files stored in an
archive (a library made using the `ar` command); a table of contents
is created from the archive file
* shared/s_dir_YYMMDD/component.mk - tailors the build system to
construct an archive containing a single object file with a single
function in it; this was an expirement in handling different revisions
of the same component

## make Targets

Using the build system is straightforward:

`make BUILD_TYPE={release|debug} ARCH_TYPE={x86_32|x86_64}
-f ../../build_system/build_utilities/makefile
{all|clean|cleanall|checkit|docs}`

A standard set of targets are defined in the makefile. Use
these target to build, etc.

* all - this is the default target and it directs make to build
everything; defined in component.mk
* clean - use this target  clean-up flotsam from a prior build
but leave some things as they are, _e.g._, the dependency files;
defined in makefile
* cleanall - use this target to clean-up everything that was
generated by a prior build; defined in makefile
* checkit - outputs the configuration of the make system for
this component; defined in makefile
* docs - used to generate the project documentation using
Doxygen

## Other Trivia

### Doxygen and Doxyfile

Doxygen is used to generate developer documentation directly from the source.
Rather than have every directory under src have its own `Doxyfile` (the name
of the configuration file), I have a single project wide `Doxyfile` that is
configured using variables set in the make files. If you use the make system,
generating the documentation is as simple as `make ... -f path/to/makefile
docs`. The variables are automatically set and passed in on the call to
Doxygen.

### Docker Containers

The toolchain will run in a Docker container. The `Dockerfile` builds the container
using the latest version of Ubuntu 18.04 (desktop). If you build the container,
expect it to take quiet a bit of time (on the order of an hour).

Note that `Dockerfile.alp` is an incomplete attempt to build the toolchain on the
latest Alpine Linux distribution (BusyBox-based). The main problem I have had is
Alpine is based on musl's clib rather than GCC's clib. This causes no end of
problems when compiling GCC 9.2.0. I may or may not finish that project.

For information on installing Docker on Ubuntu 18.04, see [Docker install](https://docs.docker.com/engine/install/ubuntu/).

## About this Project

This "project" is a glorified "Hello, World!". I created enough
in the way of source code to test the build system. It contains:

* [src/hello](https://github.com/neocliff/my-make-things/blob/master/src/hello) -
This is the directory has hello.c containing main()
and a single header, include/hello.h. The header has a BITSIZE #define
that is controlled by an externally specified make file, component.mk.
main() calls functions defined in a_dir and b_dir source code files.
Those files are linked to hello and the include directories are
added to the INCLUDE_DIRS variable in component.mk.
* [src/hello/c_dir](https://github.com/neocliff/my-make-things/blob/master/src/hello/c_dir) -
This subdirectory of src/hello demonstrates that
a component can have directories within it. This is a useful way of
partitioning functionality.
* [src/a_dir](https://github.com/neocliff/my-make-things/blob/master/src/a_dir) -
This directory has two source files, a.c and a2.c,
each with a corresponding header file. The function in a.c (called
a()) calls a function a2() in a2.c. These source files are compiled
to object code (.o files) and the .o files are linked into hello.
* [src/b_dir](https://github.com/neocliff/my-make-things/blob/master/src/b_dir) -
This directory has two source files, b1.c and b2.c,
and a single header file called include/b.h. hello's main() calls
b1() (b1.c) and b1() calls b2() (in b2.c). These source files
are compiled to object files (.o's). The .o files are then added
to an archive (or library). That .ar file is then linked into
hello.
* [src/shared/s_dir_YYMMDD](https://github.com/neocliff/my-make-things/blob/master/src/shared) -
The two subdirectories in src/shared present an
approach for handling instances where multiple versions of the same
files are used. On a large project with multiple binaries and
components, it is not out of the question that multiple versions
of the same library would be used. The best way to deal with this
is to rationalize the library into a single version however that isn't
always possible. The file [src/hello/component.mk](https://github.com/neocliff/my-make-things/blob/master/src/hello/component.mk)
has details for selecting the library version. Of course there are
limits to this: you can't have a single binary with two components
each of which requires a different revision of the same library.
If that happens to you, you've got problems!

As I said, this source is contrived and is intended to prove
capability of the build system not demonstrate I can write amazing
code. Hopefully, you find it has useful ideas as a starting point for
your own projects.

## Tools I Used

I'm using a VM running Ubuntu 18.04.4 64-bit desktop with GNOME. We made a
decision on the project at work to upgrade the toolset now rather than
"someday". Because "someday" never comes, right?

Before you can build the final toolset, you need to install the following using
your favorite package manager (_e.g._, `sudo apt install -y <package(s)>)`,
either on your system, within a VM, or using Docker and the `Dockerfile` herein:

* wget
* sudo (needed to allow user to do privileged commands in container)
* ssh
* build-essential (gets you make 4.1, gcc 7.5, sed 4.4, binutils 2.30)
* g++-multilib (required to build x86_32/x86_64 compiler)
* flex (gets you m4 1.4.18), bison
* libtool
* texinfo
* xz-utils
* doxygen
* git
* python3, python3-pip

Other tools like Perl and GZip are pre-installed and are of a version sufficient
to build the tools from source.

You need to download the following source code packages. Note that you don't
need to download and build `m4` and `sed` if the packages yield the versions
listed below. (They do at the time of writing this.) I've left the `RUN` steps
to download and build them but they are commented out. This is not the case with
`gawk`. The Ubuntu repo has version 4.1.4 and we are specing 5.0.1.

* m4-1.4.18
* sed-4.8
* gawk-5.0.1
* binutils-2.34
* make-4.3
* gcc-9.3.0 with gmp (4.3.2 or later), mpfr (3.0.1 or later), mpc (1.0.1 or
later), isl^ (0.15 or later), and zstd^ (latest)

^ The `isl` and `zstd` libraries are required to use the Link-Time Optimization
features in GCC and the new linker/loader, `gold`.

Everything except `binutils` and `gcc` is a stock build process. Best practice is
to create a separate build directory outside of the source directory. It's only
required for building GCC but recommended for the other elements. The generic
process looks like:

* download source package to your desktop
* gunzip/untar/etc the archive: `$ gunzip --to-stdout ~/Desktop/<package>.tar.gz | tar -xv`
* make a build directory: `$ mkdir ~/Desktop/build-<package>`
* change to the build directory: `$ cd ~/Desktop/build-<package>`
* run the command: `$ ../<package-rev>/configure`
* make the code: `$ make`
* drink tea in varying amounts
* install the package: `$ sudo make install`
* update the shells knowledge: `hash -r`
* check the version: `$ <program> --version`

Two of the packages require options for the `configure` commands:

* For binutils-2.33.1: `$ ../binutils-2.33.1/configure --enable-targets=all
--enable-gold --enable-lto`
* For gcc-9.2.0: `$ ../gcc-9.2.0/configure --with-cpu-32=i686 --with-cpu-64=core2
--enable-shared --enable-libstdcxx --with-multiarch --with-multilib-list=m32,m64
--enable-languages=c,c++,lto --enable-threads=posix --enable-lto
--with-gnu-gold --with-gnu-as`

Note that the `--with-cpu-32=i686 --with-cpu-64=core2` are not required. They
simply provide default values for the target CPU when building for x86_32 and
x86_64 chips. We have some baseline requirements we have to meet.

You may also want to add a `--prefix=/usr` to all the `configure` invocations.
This is replace existing installs of tools like GCC and Make. It also means that
`cmake` (assuming you use it) will be able to find the tools.
