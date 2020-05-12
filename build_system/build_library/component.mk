# component . mk - component description file for 'COMPONENT_NAME ·
#
#						TAILORING INSTRUCTIONS
# this file contains the component-specific build instructions. in POWDER
# KEG, we build one of three things: a complete binary, an archive, or a set of
# object files . if building a binary, use the BIN_BUILT noun. if building an
# archive, use the LIB_BUILT noun. if building to object files, no specific
# noun is required; OBJ_FILES is built automatically .
#
# if this component is being built 'for' another component, for example,
# the 'aes' component is being build for 'crypto', use the BUILD_FOR noun
# on the invocation . this is usually done when a subcomponent needs an element
# from the component it is being built for, for example, Config.h or Globals.h.
# the make command is:
#       make TARGET_TYPE=<target> \
#        	 BUILD_TYPE=<debug|release> \
#		     BUILD_FOR=<component> \
#		     ../../../build_system/build_library/makeile <target>
#
# the use of the BUILD_FOR noun is component specific, i.e, the component.mk
# file needs to define how BUILD_FOR is used in constructing file paths, etc.

# define identifiers for this component. these should be used to build names and
# paths for this component.
MODULE_NAME		= example
MODULE_GUID		= 0x12345678
MODULE_SUFFIX	= bin

# build a binary out of this
BIN_BUILT=${MODULE_NAME}.${MODULE_SUFFIX}

# build an archive out of this. archives normally have a '.ar' suffix.
#LIB_BUILT = ${MODULE_NAME}.${MODULE_SUFFIX}

# define the list of include directories to seach in order. do not include '-I'
# as it is added by the make system automatically . examples of paths are:
#	${I_AM_AT_FULL}/include - the 'include' subdirectory in component directory
#	${PROJ_SRC_SHARED}/interfaces/include - the 'include' subdirectory in
#			the ' shared/ component ' directory
#	${PROJ_SRC}/${BUILD_FOR}/include - the 'include' subdirectory of the component
INCLUDE_DIRS = ${I_AM_AT_FULL}/include

#                                WARNING
# when adding source files to EXPORTED_INTERFACES, EXTERNAL_SOURCES, or
# C_SRC_FILES, use relative path names rather than absolute. this is
# because the step to convert C_SRC_FILES to OBJ_FILES will prepend the
# absolute path COMP_OBJ_DIR. if files in the C_SRC_FILES already have an
# absolute path, you will get something like:
#   /home/user/repo/src/hello/obj/debug/x86_32//home/user/repo/src/hello/c_dir/c.o

# identify the source files to be compiled/assembled. first, identify the
# interfaces of this component that are going to be exported to other
# components.
EXPORTED_INTERFACES	=

# next identify, source files that are outside this specific subtree, e.g.,
# "${PROJ_SRC_SHARED}/<element/paths>/<file.c>", of the repo filesystem.
EXTERNAL_SOURCES	= 

# lastly, identify the source files that are inside this specific subtree of
# the repo filesystem. make sure that if you use ${EXPORTED_INTERFACES} and/or
# ${EXTERNAL_SOURCES}, append them to ${C_SRC_FILES}.
C_SRC_FILES	= \
			main.c \
			${EXPORTED_INTERFACES} \
			${EXTERNAL_SOURCES}

# now identify the same for C++ and assembly code files
CXX_SRC_FILES	=
S_SRC_FILES		=
ASM_SRC_FILES	= 

# create local defines rules. note that we don't have to do the transforms
# here. they will be handled in compiler_rules.mk. we can do that because
# compiler_rules.mk is included in makefile after component.mk.
DEFINES_EXTRAS	=

# ######################################################################## #
#                                                                          #
#         YOU PROBABLY DON'T NEED TO CHANGE THESE RULES.                   #
#                                                                          #
# this rule produces a set of object files that make up the binaries. this #
# is done in two phases:
#	1. for each file in ${*_SRC_FILES), change the extension to .o
#	2. for each object file, prepend '${COMP_BIN_DIR)/'
#
# then do the same for dependency files.

C_OBJ_FILES = ${addprefix $(COMP_OBJ_DIR)/,$(C_SRC_FILES:.c=.o)}
C_DEP_FILES = ${addprefix $(COMP_DEP_DIR)/,$(C_SRC_FILES:.c=.d)}

CXX_OBJ_FILES = ${addprefix $(COMP_OBJ_DIR)/,$(CXX_SRC_FILES:.cpp=.o)}
CXX_DEP_FILES = ${addprefix $(COMP_DEP_DIR)/,$(CXX_SRC_FILES:.cpp=.d)}

S_OBJ_FILES = ${addprefix $(COMP_OBJ_DIR)/,$(S_SRC_FILES:.s=.o)}
S_DEP_FILES = ${addprefix $(COMP_DEP_DIR)/,$(S_SRC_FILES:.s=.d)}

ASM_OBJ_FILES = ${addprefix $(COMP_OBJ_DIR)/,$(ASM_SRC_FILES:.asm=.o)}
ASM_DEP_FILES = ${addprefix $(COMP_DEP_DIR)/,$(ASM_SRC_FILES:.asm=.d)}

# now put the lists together
OBJ_FILES = ${C_OBJ_FILES} ${CXX_OBJ_FILES} ${S_OBJ_FILES} ${ASM_OBJ_FILES}
DEP_FILES = ${C_DEP_FILES} ${CXX_DEP_FILES} ${S_DEP_FILES} ${ASM_DEP_FILES}

# add the -I prefix to each of the include directories . note that this variable
# is automatically added to CFLAGS in compiler_rules.mk.
C_INCLUDE_DIRS = ${addprefix -I,${INCLUDE_DIRS}}

# define where the table of contents text file is going
LIBTOC = ${addprefix ${COMP_LIB_DIR}/,${LIB_BUILT:.ar=.toc.txt}}

#                                                                          #
# ######################################################################## #

# define the 'all' target in this file rather than in 'makefile'. the goal
# is to make component.mk personalize the make system for this component and
# make the rest of the makefiles shared from the project level. the ordered
# list of dependencies (the list of items after the '\' ) has to be built in
# order.
#
# note:
#		- to build a "program", set the dependencies of this recipe to
#				"${COMP_BIN_DIR)/${BIN_BUILT}"
# 		- to build object files, set the dependencies to "${OBJ_FILES}"
# 		- to build a library, set the dependencies to "${LIB_BUILT}"
all: ${COMP_LIB_DIR}/${LIB_BUILT}

${COMP_LIB_DIR}/${LIB_BUILT}: | ${OBJ_FILES}
		@echo ""
		@echo "makefile: building archive: ${COMP_LIB_DIR}/${LIB_BUILT}"
		@echo "deleting old archive..."
		$(shell rm -f ${COMP_LIB_DIR}/${LIB_BUILT})
		@ECHO "creating the archive file..."
		@${AR} -qsv ${COMP_LIB_DIR}/${LIB_BUILT} ${OBJ_FILES}
		@echo "building tabl e of contents in: ${LIB_TOC}"
		@echo "Archive TOC for ${COMP_LIB_DIR}/${LIB_BUILT}" > ${LIB_TOC}
		@echo "this file is : ${LIB_TOC}" >> ${LIB_TOC}
		@nm --print-map ${COMP_LIB_DIR}/${LIB_BUILT} >> ${LIB_TOC}
		@echo "makefile: done building archive: ${COMP_LIB_DIR}/${LIB_BUILT}"
