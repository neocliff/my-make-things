# before anything define the shell
SHELL = /bin/sh

# before we do much of anything, define the known suffixes
.SUFFIX:
.SUFFIX: .asm .c .o

# figure out where the root of this repo is located. we have
# do this here to be able to find files we are including.
ROOT_DIR ?= $(shell git rev-parse --show-toplevel)

# now figure out where i'm located
I_AM_AT = $(shell pwd)

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

# ########################################################### #
# TARGET definitions                                          #
# ########################################################### #

# the top-level 'all' target is found in component.mk. it is
# located there because what is ultimately built for a given
# component is a program, a set of object files, or a library.
#
# the only targets defined in this makefile are generic targets.

# first, this is the target when we want to roll everything back
# to the prebuild state (i.e., we just checked the code out of
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
	@echo "makefile configured variables.."
	@echo "=============================="
	@echo "tools..."
	@echo "=============================="
	@echo "SYS_BINDIR is ${SYS_BINDIR}"
	@echo "USR_BINDIR is ${USR_BINDIR}"
	@echo "GNU_BINDIR is ${GNU_BINDIR}"
	@echo "SHELL      is ${SHELL}"
	@echo "CC         is ${CC}"
	@echo "CXX        is ${CXX}"
	@echo "LD         is ${LD}"
	@echo "TAR        is ${TAR}"
	@echo "AR         is ${AR}"

	@echo ""
	@echo "=============================="
	@echo "component stuff..."
	@echo "=============================="
	@echo "ROOT_DIR   is ${ROOT_DIR}"
	@echo "I_AM_AT    is ${I_AM_AT}"
	@echo "BUILD_TYPE is ${BUILD_TYPE}"
	@echo "ARCH_TYPE  is ${ARCH_TYPE}"
	@echo "CFLAGS     is ${CFLAGS}"
	@echo "BIN_ROOT   is ${BIN_ROOT}"
	@echo "BIN_DIR    is ${BIN_DIR}"
	@echo "BINBUILT   is ${BINBUILT}"
	@echo "LIB_ROOT   is ${LIB_ROOT}"
	@echo "LIB_DIR    is ${LIB_DIR}"
	@echo "OBJ_ROOT   is ${OBJ_ROOT}"
	@echo "OBJ_DIR    is ${OBJ_DIR}"
	@echo "INC_DIR    is ${INC_DIR}"
	@echo "DEP_ROOT   is ${DEP_ROOT}"
	@echo "DEP_DIR    is ${DEP_DIR}"
	@echo "SRCS       is ${SRCS}"
	@echo "OBJS       is ${OBJS}"
	@echo "DEPS       is ${DEPS}"

# once everything is loaded and configured, load the dependency
# files if they exist. first, make the dependencies files as
# PRECIOUS so they won't be deleted if make aborts.
.PRECIOUS: $(DEP_DIR)/%.d
$(DEP_DIR)/%.d: ;

-include $(DEPS)
