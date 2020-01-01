# before anything define the shell
SHELL = /bin/sh

# figure out where the root of this repo is located
ROOT_DIR ?= $(shell git rev-parse --show-toplevel)

# figure out where i'm located
I_AM_AT = $(shell pwd)

# building toward the insane complexity of the main project,
# supply a default BUILD_TYPE and ARCH_TYPE in case the user
# doesn't give it to us
BUILD_TYPE ?= debug
ARCH_TYPE  ?= x86_64

# figure out where the build_system directories are located.
# we need these to locate things like compiler_rules.mk and
# defaults.mk.
BUILD_SYSTEM = ${ROOT_DIR}/build_system
BUILD_LIBRARY = ${BUILD_SYSTEM}/build_library
BUILD_UTILITIES = ${BUILD_SYSTEM}/build_utilities

# load the default definitions
include ${BUILD_LIBRARY}/defaults.mk

# this file defines what we are building. in particular, we
# need the list of source modules that make up the component.
include ${I_AM_AT}/component.mk

.PHONY: all checkit clean
.default: all

# define the standard paths for headerfiles. unlike this such
# as the directory for obj files, the INCDIR is a list of
# directories that is scanned to locate header files. that
# means we could have multiple paths.
INC_DIR ?= include

# define the standard paths for everything else. these can be
# redefined in the component.mk files using something like the
# following syntax:
#		OBJDIR = my/obj/dir/path
DEP_ROOT	?= ${I_AM_AT}/dep
DEP_DIR		?= $(DEP_ROOT)/$(BUILD_TYPE)/$(ARCH_TYPE)
OBJ_ROOT	?= ${I_AM_AT}/obj
OBJ_DIR		?= $(OBJ_ROOT)/$(BUILD_TYPE)/$(ARCH_TYPE)
BIN_ROOT	?= ${I_AM_AT}/bin
BIN_DIR		?= $(BIN_ROOT)/$(BUILD_TYPE)/$(ARCH_TYPE)

# this rule produces a set of object files that make up the
# binary defined in $(BINBUILT). this list of object files is
# built in two parts:
#	1. for each file in $(SRCS), change the .c to a .o suffix
#	2. for each object file, prepend '$(BINDIR)/' in front
#		of the file name
OBJS = $(addprefix $(OBJ_DIR)/,$(SRCS:.c=.o))

# in a similar fashion, make the include/header dependencies
DEPS = $(addprefix $(DEP_DIR)/,$(SRCS:.c=.d))

# auto-build the directories we need. there are lots of ways
# to do this. this is brute-force but it always works. note
# the creation of the BINDIR directory is different from that
# for the objects and dependencies. that later two preserve
# intermediate directories (e.g., a/b/c.o gets us obj/a/b)
# while the first is just a path to a directory. it can be
# changed to behave the same as the other two if BIN (or BINS)
# has a path and not just a file name.
$(shell mkdir -p $(BIN_DIR) > /dev/null)
$(shell mkdir -p $(dir $(OBJS)) > /dev/null)
$(shell mkdir -p $(dir $(DEPS)) > /dev/null)

# pull in the definition of the compiler rules, a generic set
# of recipes that tell make how to transform x.y -> x.z
include ${BUILD_LIBRARY}/compiler_rules.mk

# this is the target that does it all. the ordered list of
# dependencies (the list of things after the '|') has to be
# built in order...
#	1. create target directories that doen't already exist
#	2. make the final binary as a target
all: | $(BIN_DIR)/$(BINBUILT)

# this is the target when we want to roll everything back to
# the prebuild state (i.e., we just checked the code out of
# the repo)
clean:
	rm -rf $(DEP_DIR)
	rm -rf $(OBJ_DIR)
	rm -rf $(BIN_DIR)

cleanall:
	rm -rf $(DEP_ROOT)
	rm -rf $(OBJ_ROOT)
	rm -rf $(BIN_ROOT)

# this is the target that dumps variables so that we can check
# the build process.
checkit:
	@echo "SYS_BINDIR is ${SYS_BINDIR}"
	@echo "USR_BINDIR is ${USR_BINDIR}"
	@echo "ROOT_DIR is ${ROOT_DIR}"
	@echo "I_AM_AT is ${I_AM_AT}"
	@echo "SHELL is ${SHELL}"
	@echo "CC is ${CC}"
	@echo "CXX is ${CXX}"
	@echo "LD is ${LD}"
	@echo "TAR is ${TAR}"
	@echo "AR is ${AR}"

	@echo "BUILD_TYPE is ${BUILD_TYPE}"
	@echo "ARCH_TYPE is ${ARCH_TYPE}"
	@echo "BIN_ROOT is ${BIN_ROOT}"
	@echo "BIN_DIR is ${BIN_DIR}"
	@echo "BINBUILT is ${BINBUILT}"
	@echo "OBJ_ROOT is ${OBJ_ROOT}"
	@echo "OBJ_DIR is ${OBJ_DIR}"
	@echo "INC_DIR is ${INC_DIR}"
	@echo "DEP_ROOT is ${DEP_ROOT}"
	@echo "DEP_DIR is ${DEP_DIR}"
	@echo "SRCS is ${SRCS}"
	@echo "OBJS is ${OBJS}"
	@echo "DEPS is ${DEPS}"

# make the dependencies files PRECIOUS so they won't be deleted
# if make aborts
.PRECIOUS: $(DEP_DIR)/%.d
$(DEP_DIR)/%.d: ;

-include $(DEPS)
