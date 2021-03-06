# component.mk - component's description file

# this component builds an archive (library)
LIB_BUILT = s_lib.ar

# define directory paths to header files we need
INCLUDE_DIRS = \
	${PROJ_ROOT}/src/hello/include \
	${I_AM_AT_FULL}/include

# identify source files in this component
C_SRC_FILES = s.c

# this rule produces a set of object files that make up the
# binary defined in $(BIN_BUILT). this list of object files is
# built in two parts:
#	1. for each file in $(C_SRC_FILES), change the .c to a .o suffix
#	2. for each object file, prepend '$(BINDIR)/' in front
#		of the file name
OBJ_FILES = $(addprefix $(COMP_OBJ_DIR)/,$(C_SRC_FILES:.c=.o))

# next, build the list of include directories for the compiler
C_INCLUDE_DIRS = ${addprefix -I,${INCLUDE_DIRS}}

# in a similar fashion, make the include/header dependencies
DEP_FILES = $(addprefix $(COMP_DEP_DIR)/,$(C_SRC_FILES:.c=.d))

LIBTOC = $(addprefix $(COMP_LIB_DIR)/,$(LIB_BUILT:.ar=.toc.txt))

# define the 'all' target in this file rather than in 'makefile'.
# the goal is to make component.mk personalize the make system
# for this component and make the rest of the makefiles shared
# from the project level. the ordered list of dependencies
# (the list of things after the '|') has to be  built in order.
#
# note: 
#	- to build a "program", set the dependencies of this
#	  recipe to "${COMP_BIN_DIR}/${BIN_BUILT}"
#	- to build object files, set the dependencies "${OBJ_FILES}"
#	- to build a library, set the dependencies to "${TBD}".
all: | ${COMP_LIB_DIR}/${LIB_BUILT}

${COMP_LIB_DIR}/${LIB_BUILT}: | ${OBJ_FILES}
	@echo ""
	@echo "makefile: building archive: ${COMP_LIB_DIR}/${LIB_BUILT}"
	@echo "deleting old archive copy..."
	@$(shell rm -rf ${COMP_LIB_DIR}/${LIB_BUILT})
	@echo "createing the archive file"
	@${AR} -qsv ${COMP_LIB_DIR}/${LIB_BUILT} ${OBJ_FILES}
	@echo "building table of contents in: ${LIBTOC}"
	@echo "Archive TOC for: ${COMP_LIB_DIR}/${LIB_BUILT}" > ${LIBTOC}
	@echo "This file is   : ${LIBTOC}" >> ${LIBTOC}
	@nm --print-armap ${COMP_LIB_DIR}/${LIB_BUILT} >> ${LIBTOC}
	@echo "makefile: done building archive: ${COMP_LIB_DIR}/${LIB_BUILT}"
