# The build_library Directory

## Overview

The build_library directory is for things like make files or configuration files
that are shared by the entire project. If a component somewhere in the
project requires a tailored version of one of these files and it
can't be tailored using the standard mechanisms, it should then it
should have the tailored copy in the directory with the other
component files.

as a rule, if the file has '+x' in the permissions, it belongs in
build_utilities. otherwise, this is the right place for it.

* compiler_rules.mk - this make file contains all the default rules to
turn source code into object code. the object code is then built into
libraries or executable binaries
* defaults.mk - defines all the default programs and variables used in the
build system
* Doxyfile - the project Doxygen configuration file. note that you should not
invoke Doxygen directly; always use the "make ... -f path/to/makefile docs"
command instead. doing that ensures all the needed variables get set and passed
into the Doxyfile.
* makefile - this is the file in the "make ... -f path/to/makefile target"
command

## A note about Using Doxygen

If you have a set of `#define` values, macro definitions, or variables and you
want the documentation to apply to all of them, there are two things you need
to do.

1. First, wrap the macros, variables, etc., using `@{` and `@}`.
2. In the Doxyfile, set `DISTRIBUTE_GROUP_DOC` to `YES`.

For example, consider the following extract from a C-language header file.
Notice the two markers indicating the start and end of the commented group of
values.

```C
/**
 * @brief define the version of the program
 *
 * Defines the version of the program using the standard:
 * major/minor/patch level/build number.
 *
 * @note the build number is specified via a define in the makefile.
 *
 * @note If you want the comments applied to a group of defines, use the 
 * syntax shown here **and** in your `Doxyfile`, set `DISTRIBUTE_GROUP_DOC` to `YES`.
 * If you don't, the comments will only apply to the first define/macro/variable
 * in the group.
 */
//@{
#define VERSION_MAJOR 1
#define VERSION_MINOR 0
#define VERSION_PATCH 50
//@}
```
