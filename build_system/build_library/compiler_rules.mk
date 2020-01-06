# compiler_rules.mk - contains all the standard definitions of rules
#	to transform source into objects and libraries, and objects and
#	libraries into finished binaries.

# CFLAGS contains the default flags used to compile C code
CFLAGS = \
		-Wall \
		-pedantic

# if we are doing a "debug" build, include the debugging information
# (symbol tables, etc) but remove information for unused symbols. 
# see the post-build steps in makefile for what to do for "release"
# builds.
ifeq (${BUILD_TYPE},debug)
CFLAGS += -g -feliminate-unused-debug-symbols
endif

# set additonal CFLAGS values based on architecture type
ifeq (${ARCH_TYPE},x86_32)
CFLAGS += -m32 -DPROCESSOR_X86_32
else
CFLAGS += -DPROCESSOR_X86_64
endif

# loader flags
LDFLAGS = -L/lib/ -L/usr/lib/ -L/usr/lib/x86_64-linux-gnu -Map=${COMP_BIN_DIR}/linker_map.txt -cref /usr/lib/x86_64-linux-gnu/crti.o -lc

# PRIMER ON GNU MAKE'S LEXICON
#
# this is a quick-and-dirty primer on terms used in GNU make.
#
# [target]+: [pre-requisite]*
#	[rule]*
#
# recipe - the description of how to make something; think cooking and
#		you're on the right track
# target - the thing (or things) to be made; see '$@' below
# pre-requisite -: zero or more things that must be up-to-date to make
#		the target
# rule	- zero or more steps to be executed to make the target
#
# GNU MAKE'S AUTOMATIC VARIABLES
#
# a word is in order about GNU make's plethora of target and dependency
# variables. they are there to make life easier when writing recipes
# however without a cheatsheet they are a confusing mess. The following
# is an almost verbatim extract from make 4.2's manual, pp. 120-1.
#	$@ - The file name of the target of the rule. If the target is an
#		archive member, then ‘$@’ is the name of the archive file. In
#		a pattern rule that has multiple targets, ‘$@’ is the name
#		of whichever target caused the rule’s recipe to be run.
#	$% - The target member name, when the target is an archive member.
#		For example, if the target is foo.a(bar.o) then ‘$%’ is bar.o
#		and ‘$@’ is foo.a. ‘$%’ is empty when the target is not an
#		archive member.
#	$< - The name of the first prerequisite. If the target got its
#		recipe from an implicit rule, this will be the first 
#		prerequisite added by the implicit rule.
#	$? - The names of all the prerequisites that are newer than the
#		target, with spaces between them. For prerequisites which are
#		archive members, only the named member is used.
#	$^ -  The names of all the prerequisites, with spaces between them.
#		For prerequisites which are archive members, only the named member
#		is used. A target has only one prerequisite on each other file it
#		depends on, no matter how many times each file is listed as a
#		prerequisite. So if you list a prerequisite more than once for a
#		target, the value of $^ contains just one copy of the name. This
#		list does not contain any of the order-only prerequisites; for
#		those see the ‘$|’ variable, below.
#	$+ - This is like ‘$^’, but prerequisites listed more than once are
#		duplicated in the order they were listed in the makefile. This
#		is primarily useful for use in linking commands where it is
#		meaningful to repeat library file names in a particular order.
#	$| - The names of all the order-only prerequisites, with spaces
#		between them.
#	$* - The stem with which an implicit rule matches. If the target is
#		dir/a.foo.b and the target pattern is a.%.b then the stem is
#		dir/foo. The stem is useful for constructing names of related
#		files.
#
#		In a static pattern rule, the stem is part of the file name that
#		matched the ‘%’ in the target pattern.
#
#		In an explicit rule, there is no stem; so ‘$*’ cannot be
#		determined in that way. Instead, if the target name ends with a
#		recognized suffix, ‘$*’ is set to the target name minus the
#		suffix. For example, if the target name is ‘foo.c’, then ‘$*’ is
#		set to ‘foo’, since ‘.c’ is a suffix. GNU make does this bizarre
#		thing only for compatibility with other implementations of make.
#		You should generally avoid using ‘$*’ except in implicit rules or
#		static pattern rules.
#
#		If the target name in an explicit rule does not end with a
#		recognized suffix, ‘$*’ is set to the empty string for that rule.

# AUTOMATIC GENERATION OF DEPENDENCY FILES
#
# DEPFLAGS contains the default flags given to the compiler to generate
# dependency files and targets. as much as i hate tricky stuff in
# makefiles, this is probably (and *only* probably) warranted. buyer
# beware!
#	-MT <target> - removes the default prefix directory components and
#		the suffix and applies the default object suffix
#	-MD - equivalent to '-M -MF <file>' except that -E is not implied.
#		in most cases this removes the directory components and the
#		source suffix and applies a '.d' suffix. this generates the
#		output dependency file as a side effect of the compilation stage.
#		ugh! note that using '-MMD' causes the dependency generator to
#		ignore system files. if you have a really large project, you 
#		might want to use that instead.
#	-MP - creates a PHONY target for each dependency other that the main
#		file, cause each to depend on nothing. these dummy rules get 
#		around errors make generates if you remove header files without
#		updating the make file.
#	-MF <target> - specifies the name of the file to send the dependencies.
#		without this switch, the output is sent to the same place it
#		would send the preprocessor output. this overrides the default
#		file name generated by '-MD' and '-MMD'. it will only generate
#		dependencies for the project header files.
#
#	note: this was set to generate dependencies on project and sytem
#		header files. this behavior is set by the '-MD' switch. you might
#		want this if you are figure out x86_32 vs. x86_64 issues. if this
#		becomes unweildy, use the '-MMD' switch instead.
DEPFLAGS = -MT $@ -MD -MP -MF $(COMP_DEP_DIR)/$*.Td

# use this command to save the dependencies files.
SAVE.d = mv -f ${COMP_DEP_DIR}/$*.Td ${COMP_DEP_DIR}/$*.d

# COMPILATION, ASSEMBLY, ETC DEFAULT RULES
#
# we are going to define some compiler rules. i wouldn't normally do it
# this way but the example i'm using does. if you don't like this, break
# if for your specific project.
COMPILE.c = ${CC} ${INCLUDE_DIRS} ${DEPFLAGS} ${CFLAGS} -c -o $@

# this is the default recipe to build a program binary. it should only
# be invoked for a component that results in a finished binary (i.e.,
# a program). do *not* use this rule if the intent of the component is 
# just a set of object files that other components pick-and-chose from.
# also, don't use this recipe to construct a library used for shared
# or static linking.
#${COMP_BIN_DIR}/${BIN_BUILT}: ${OBJ_FILES}
#	@echo ""
#	@echo "makefile: linking '${COMP_BIN_DIR}/${BIN_BUILT}' from '${OBJ_FILES}'"
#	$(CC) -o ${COMP_BIN_DIR}/${BIN_BUILT} ${OBJ_FILES}

# default compilation rule to turn a '.c' file into a '.o'
${COMP_OBJ_DIR}/%.o: %.c
${COMP_OBJ_DIR}/%.o: %.c ${COMP_DEP_DIR}/%.d
	@echo ""
	@echo "makefile: compiling '$@' from '$<'"
	${COMPILE.c} $<
	@echo "makefile: moving dependency file to ${COMP_DEP_DIR}/$*.d"
	${SAVE.d}
