# component.mk - component's description file

# this component results in a finished binary program so name it
BIN_BUILT = hello

# this is an idea of how to deal with components needing different
# versions of a library, where versions cannot be rationalized into
# a single "super-version".
S_DIR_VERSION = 200105

# define the paths to the header files needed for this component. this variable
# is passed to Doxygen as is *and* is transformed into C_INCLUDE_DIRS below.
# Doxygen doesn't want the '-I' but the compiler does.
INCLUDE_DIRS = \
	${I_AM_AT}/include \
	${I_AM_AT}/c_dir/include \
	${PROJ_SRC}/a_dir/include \
	${PROJ_SRC}/b_dir/include \
	${PROJ_SRC}/shared/s_dir_${S_DIR_VERSION}/include

C_SRC_FILES := hello.c \
		${I_AM_AT}/c_dir/c.c

C_SRC_EXTRAS := \
		shared/s_dir_${S_DIR_VERSION}/s.c

OBJS_EXTRAS = \
	${PROJ_SRC}/a_dir/obj/${BUILD_TYPE}/${ARCH_TYPE}/a.o \
	${PROJ_SRC}/a_dir/obj/${BUILD_TYPE}/${ARCH_TYPE}/a2.o

LIBS_EXTRAS = \
	${PROJ_SRC}/b_dir/lib/${BUILD_TYPE}/${ARCH_TYPE}/b_lib.ar \
	${PROJ_SRC}/shared/s_dir_${S_DIR_VERSION}/lib/${BUILD_TYPE}/${ARCH_TYPE}/s_lib.ar

# the next few rules shouldn't have to be changed for the component.
# the first rule produces a list of object files that make up the
# binary defined in $(BIN_BUILT). this list of object files is
# built in two parts:
#	1. for each file in $(C_SRC_FILES), change the .c to a .o suffix
#	2. for each object file, prepend '$(BINDIR)/' in front
#		of the file name
OBJ_FILES = ${addprefix ${COMP_OBJ_DIR}/,${C_SRC_FILES:.c=.o}}

# next, build the list of include directories for the compiler
C_INCLUDE_DIRS = ${addprefix -I,${INCLUDE_DIRS}}

# in a similar fashion, make the include/header dependencies
DEP_FILES = ${addprefix ${COMP_DEP_DIR}/,${C_SRC_FILES:.c=.d}}

# TAILORING REQUIRED...
#
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
all: | ${COMP_BIN_DIR}/${BIN_BUILT}

${COMP_BIN_DIR}/${BIN_BUILT}: ${OBJ_FILES} ${OBJS_EXTRAS}
	@echo ""
	@echo "makefile: linking '${COMP_BIN_DIR}/${BIN_BUILT}' from '${OBJ_FILES}'"
	@echo "          adding objects files: ${OBJS_EXTRAS}"
	@echo "          adding archive files: ${LIBS_EXTRAS}"
	${CC}  ${CFLAGS} -Wl,-Map=${COMP_BIN_DIR}/linker_map.txt -Wl,-cref -o ${COMP_BIN_DIR}/${BIN_BUILT} ${OBJ_FILES} ${OBJS_EXTRAS} ${LIBS_EXTRAS}
	@echo "makefile: calling post-build step"
	${POST_BUILD} ${COMP_BIN_DIR}/${BIN_BUILT}