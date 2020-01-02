# component.mk - component's description file

# this component builds an archive (library)
LIBBUILT = b_lib.ar
LIBTOC = b_lib.toc.txt

# define directory paths to header files we need
INC_DIR = \
	-I${I_AM_AT}/include

# identify source files in this component
SRCS = b1.c b2.c

# this rule produces a set of object files that make up the
# binary defined in $(BINBUILT). this list of object files is
# built in two parts:
#	1. for each file in $(SRCS), change the .c to a .o suffix
#	2. for each object file, prepend '$(BINDIR)/' in front
#		of the file name
OBJS = $(addprefix $(OBJ_DIR)/,$(SRCS:.c=.o))

# in a similar fashion, make the include/header dependencies
DEPS = $(addprefix $(DEP_DIR)/,$(SRCS:.c=.d))

# define the 'all' target in this file rather than in 'makefile'.
# the goal is to make component.mk personalize the make system
# for this component and make the rest of the makefiles shared
# from the project level. the ordered list of dependencies
# (the list of things after the '|') has to be  built in order.
#
# note: 
#	- to build a "program", set the dependencies of this
#	  recipe to "${BIN_DIR}/${BINBUILT}"
#	- to build object files, set the dependencies "${OBJS}"
#	- to build a library, set the dependencies to "${TBD}".
all: | ${LIB_DIR}/${LIBBUILT}

${LIB_DIR}/${LIBBUILT}: | ${OBJS}
	@echo ""
	@echo "makefile: building archive: ${LIB_DIR}/${LIBBUILT}"
	@echo "deleting old archive copy..."
	@$(shell rm -rf ${LIB_DIR}/${LIBBUILT})
	@echo "createing the archive file"
	@${AR} -qsv ${LIB_DIR}/${LIBBUILT} ${OBJS}
	@echo "building table of contents"
	@nm -s ${LIB_DIR}/${LIBBUILT} > ${LIB_DIR}/${LIBTOC}
	@echo "makefile: done building archive: ${LIB_DIR}/${LIBBUILT}"
