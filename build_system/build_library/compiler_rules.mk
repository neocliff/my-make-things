# compiler_rules.mk - contains all the standard definitions of rules
#	to transform source into objects and libraries, and objects and
#	libraries into finished binaries.

# Differences between CFLAGS and DEFINES...
#
# because we are using Doxygen to generate documentation, we need to pass it the
# preprocessor defines. the C compiler want's '-D' in front of each while
# Doxygen does not. rather than maintaining two lists of defines, we can use
# make's `addprefix` trick to make the change. also, i like to seperate settings
# of the compiler flags from the defines. it makes things a bit wordier but i
# find it cleaner and easier to understand.

# CFLAGS contains the default flags used to compile C code. the code is mostly
# C'99 with a few C'11-isms for fun. We use `-std=gnu11` because they have
# non-compliant variadic macros.
CFLAGS = \
		-std=gnu11 \
		-Wall \
        -Wextra \
		-Wpedantic \
        -Wno-vla \
        -Wno-builtin-declaration-mismatch \
        -masm=intel \
        -mstringop-strategy=rep_4byte \
        -fno-inline

# if we are doing a "debug" build, include the debugging information
# (symbol tables, etc) but remove information for unused symbols.
# see the post-build steps in makefile for what to do for "release"
# builds.
ifeq (${BUILD_TYPE},debug)
CFLAGS  += -g \
		-feliminate-unused-debug-symbols
endif

# set flags for "release" builds
ifeq (${BUILD_TYPE},release)
CFLAGS  += \
        -Os
endif

# set additonal CFLAGS values based on architecture type. project assumptions:
#   32-bit - use i686 as the machine architecture
#   64-bit - use core2 as the machine architecture
#
# for gcc, x86- bitness is defined using the following flags:
#   -m32 - builds 32-bit binaries (32-bit pointers, ints, longs) for i386-type
#   -mx32 - builds 32-bit binaries for 64-bit hardware (32-bit pointers,
#          ints, longs)
#   -m64 - builds 64-bit binaries (64-bit pointers, longs, 32-bit ints)
ifeq (${ARCH_TYPE},x86_32)
CFLAGS  += \
        -m32 \
        -march=i686
else
CFLAGS  += \
        -m64 \
        -march=core2
endif

# next create the #define values that control the source included/selected by
# the preprocessor. at the same time, set the same defines for generating
# Doxygen document generation. remember when setting them that C DEFINES
# require a '-D' prefix but DOXY DEFINES do not.

# first, set defines to indicate if we are doing a debug build
ifeq (${BUILD_TYPE},debug)
DEFINES += \
		_DEBUG \
        DEBUG
endif

# now set CPU-related defines based on processor class. assume we are doing
# x86_64 if we are not explicitly doing x86_32.
ifeq (${ARCH_TYPE},x86_32)
DEFINES += PROCESSOR_X86_32
else
DEFINES += PROCESSOR_X64 PROCESSOR_X86_64
endif

# next step for defines is to prepare the string for the compiler and then
# add that string to the CFLAGS variable. the setting for Doxygen happens in
# defaults.mk.
C_PREPROCESSOR_DEFINES = ${addprefix -D,${DEFINES}}
DOXY_PREPROCESSOR_DEFINES ?= ${DEFINES}
ifneq (${DEFINES_EXTRAS},)
C_PREPROCESSOR_DEFINES      += ${addprefix -D,$(DEFINES_EXTRAS)}
DOXY_PREPROCESSOR_DEFINES   += ${DEFINES_EXTRAS}
endif

# last step is to add the defines to CFLAGS
CFLAGS += ${C_PREPROCESSOR_DEFINES}

# c++ flags. at the moment, the project has no c++ code but we'll plumb for
# it just in case.
CXXFLAGS =

# set some assembler flags
ASFLAGS =

# loader flags. note: i have no idea if these make sense or not. they crept in
# when I wasn't looking.
LDFLAGS = -L/lib/ \
			-L/usr/lib/ \
			-L/usr/lib/x86_64-linux-gnu -Map=${COMP_BIN_DIR}/linker_map.txt \
			-cref /usr/lib/x86_64-linux-gnu/crti.o -lc

# next the nm flags. this is used to get the symbols from a binary (obj|bin)
NMFLAGS = --print-armap

# if this is a debug build, add the debug symbols to the map
ifeq (${BUILD_TYPE},debug)
NMFLAGS += \
        --debug-syms
endif

# PRIMER ON GNU MAKE'S LEXICON
#
# this is a quick-and-dirty primer on terms used in GNU make.
#
# [target]+: [pre-requisite]*
#	[rule]*
#
# recipe - the description of how to make something; think cooking and
#		you're on the right track
# target - the thing (or things) to be made; think dish in cooking see '$@' below
# pre-requisite -: zero or more things that must be up-to-date to make
#		the target; ingredients to cook with
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
COMPILE.c = ${CC} ${C_INCLUDE_DIRS} ${DEPFLAGS} ${CFLAGS} -c -o $@

# default compilation rule to turn a .c/.cpp file into a .o. this is applied
# to C/C++ files that do not require any fiddling with the assembly language.
${COMP_OBJ_DIR}/%.o: %.c
${COMP_OBJ_DIR}/%.o: %.c ${COMP_DEP_DIR}/%.d
	@echo ""
	@echo "makefile: COMPILING '$@' FROM '$<'"
	${COMPILE.c} $<
	@echo "makefile: moving dependency file to ${COMP_DEP_DIR}/$*.d"
	${SAVE.d}

${COMP_OBJ_DIR}/%.o: %.cpp
${COMP_OBJ_DIR}/%.o: %.cpp ${COMP_DEP_DIR}/%.d
	@echo ""
	@echo "makefile: COMPILING '$@' FROM '$<'"
	${COMPILE.c} ${CXXFLAGS} $<
	@echo "makefile: moving dependency file to ${COMP_DEP_DIR}/$*.d"
	${SAVE.d}

# default compilation rule to turn a .asm file into a .o. this is applied to
# assembly language file that does not require any intermediate fiddling before
# final assembly.
# ${COMP_OBJ_DIR}/%.o: %.asm
# ${COMP_OBJ_DIR}/%.o: %.asm ${COMP_DEP_DIR}/%.d
#     @echo""
#     @echo "$(COLOR CYAN) makefil.e: compiling $@ from $< $(COLOR NORMAL)"
#     ${AS} ${C_INCLUDE_DIRS} ${DEPFLAGS} ${ASFLAGS} -o $@ $<
#     @echo "makefile: move dependency file to ${COMP_DEP_DIR}/$*.d"
#     ${SAVE.d}
