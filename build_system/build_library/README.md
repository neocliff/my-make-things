build_library is for things like make files or configuration files that
are shared by the entire project. if a component somewhere in the 
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