# before anything define the shell
SHELL = /bin/sh

# before we do much of anything, define the known suffixes. i've
# added a couple variants that i often see.
.SUFFIX:
.SUFFIX: .asm .s .c .cpp .cxx .h .o

# figure out where the root of this repo is located. we have
# do this here to be able to find files we are including.
PROJ_ROOT ?= $(shell git rev-parse --show-toplevel)

# now figure out where i'm located. need two versions of this:
#	I_AM_AT_FULL = absolute path to the current working directory
#	I_AM_AT_PART = is the part of ${I_AM_AT_FULL} minus ${PROJ_ROOT}
I_AM_AT_FULL = $(shell pwd)
I_AM_AT_PART = $(subst ${PROJ_ROOT}/,,${I_AM_AT_FULL})

# figure out where the build_system directories are located.
# we need these to locate things like compiler_rules.mk and
# defaults.mk.
BUILD_SYSTEM = ${PROJ_ROOT}/build_system
BUILD_LIBRARY = ${BUILD_SYSTEM}/build_library
BUILD_UTILITIES = ${BUILD_SYSTEM}/build_utilities

# load the default definitions
include ${BUILD_LIBRARY}/defaults.mk

# this file defines what we are building. in particular, we
# need the list of source files that make up the component.
include ${I_AM_AT_FULL}/component.mk

.PHONY: all check-config check-tools clean clean-all install install-strip
.default: all

# auto-build the directories we need. there are lots of ways
# to do this. this is brute-force but it always works. note
# the creation of the COMP_BIN_DIR and COMP_LIB_DIR directories are
# different from that for the objects and dependencies.
# that later two preserve intermediate directories
# (e.g., a/b/c.o gets us obj/a/b) while the first two are just
# paths to directories. they can be changed to behave the same
# as the other two if BIN (or BINS) has a path and not just a
# file name.
$(shell mkdir -p ${COMP_BIN_DIR} > /dev/null)
$(shell mkdir -p ${COMP_LIB_DIR} > /dev/null)
$(shell mkdir -p ${dir ${OBJ_FILES}} > /dev/null)
$(shell mkdir -p ${dir ${DEP_FILES}} > /dev/null)

# pull in the definition of the compiler rules, a generic set of recipes that
# tell make how to transform x.y -> x.z. throw an error if this file is
# missing.
include ${BUILD_LIBRARY}/compiler_rules.mk

# ########################################################### #
# TARGET definitions                                          #
# ########################################################### #

# the top-level 'all' target is found in component.mk. it is
# located there because what is ultimately built for a given
# component is a program, a set of object files, or a library.
#
# additionally, the top-level 'install' target is found in
# component.mk as well. every component is responsible for
# "delivering" its content to the distribution directories
# (if appropriate).
#
# the only targets defined in this makefile are generic targets.

# first, the target to call when we need to delete the artifacts
# of the build process. this only takes place within the component.
clean:
	rm -rf ${COMP_DEP_DIR}
	rm -rf ${COMP_OBJ_DIR}
	rm -rf ${COMP_LIB_DIR}
	rm -rf ${COMP_BIN_DIR}
	rm -rf ${DOXY_OUTPUT_DIR}

# second, this is the target when we want to roll everything back
# to the prebuild state (i.e., we just checked the code out of
# the repo)
clean-all:
	rm -rf ${COMP_DEP_ROOT}
	rm -rf ${COMP_OBJ_ROOT}
	rm -rf ${COMP_LIB_ROOT}
	rm -rf ${COMP_BIN_ROOT}
	rm -rf ${DOXY_OUTPUT_DIR}

	rm -rf ${PROJ_OBJ}
	rm -rf ${PROJ_LIB}
	rm -rf ${PROJ_DOXY_DOCS}

# this is the target that dumps information about the tools we are using
check-tools:
	@echo "SHELL           is ${SHELL}"
	@echo ""
	ls -l ${SHELL}
	@echo "----------------------------------------------------------"
	@echo "CC              is ${CC}"
	@echo ""
	${CC} --version
	@echo "----------------------------------------------------------"
	@echo "CXX             is ${CXX}"
	@echo ""
	${CXX} --version
	@echo "----------------------------------------------------------"
	@echo "LD              is ${LD}"
	@echo ""
	${LD} --version
	@echo "----------------------------------------------------------"
	@echo "TAR             is ${TAR}"
	@echo ""
	${TAR} --version
	@echo "----------------------------------------------------------"
	@echo "AR              is ${AR}"
	@echo ""
	${AR} --version
	@echo "----------------------------------------------------------"
	@echo "NM              is ${NM}"
	@echo ""
	${NM} --version
	@echo "----------------------------------------------------------"
	@echo "SED             is ${SED}"
	@echo ""
	${SED} --version
	@echo "----------------------------------------------------------"
	@echo "GAWK            is ${GAWK}"
	@echo ""
	${GAWK} --version

# this is the target that dumps variables so that we can check
# the build process.
check-config:
	@echo "makefile configured variables.."
	@echo "=============================="
	@echo "tools..."
	@echo "=============================="
	@echo "TERM            is ${TERM}"
	@echo "SYS_BINDIR      is ${SYS_BINDIR}"
	@echo "USR_BINDIR      is ${USR_BINDIR}"
	@echo "USR__LCL_BINDIR is ${USR_LCL_BINDIR}"
	@echo "SHELL           is ${SHELL}"
	@echo "CC              is ${CC}"
	@echo "CXX             is ${CXX}"
	@echo "LD              is ${LD}"
	@echo "TAR             is ${TAR}"
	@echo "AR              is ${AR}"
	@echo "NM              is ${NM}"
	@echo "PRE_BUILD       is ${PRE_BUILD}"
	@echo "POST_BUILD      is ${POST_BUILD}"

	@echo ""
	@echo "=============================="
	@echo "component stuff..."
	@echo "=============================="
	@echo "PROJ_ROOT                 is ${PROJ_ROOT}"
	@echo "PROJ_SRC                  is ${PROJ_SRC}"
	@echo "PROJ_SRC_SHARED           is ${PROJ_SRC_SHARED}"
	@echo "PROJ_LIB                  is ${PROJ_LIB}"
	@echo "PROJ_LIB_SHARED           is ${PROJ_LIB_SHARED}"
	@echo "PROJ_DOXY_DOCS            is ${PROJ_DOXY_DOCS}"
	@echo "I_AM_AT_FULL              is ${I_AM_AT_FULL}"
	@echo "I_AM_AT_PART              is ${I_AM_AT_PART}"
	@echo "BUILD_TYPE                is ${BUILD_TYPE}"
	@echo "ARCH_TYPE                 is ${ARCH_TYPE}"
	@echo "CFLAGS                    is ${CFLAGS}"
	@echo "DOXY_ROOT                 is ${DOXY_ROOT}"
	@echo "DOXY_OUTPUT_DIR           is ${DOXY_OUTPUT_DIR}"
	@echo "DOXY_CONFIG               is ${DOXY_CONFIG}"
	@echo "DOXY_COMPONENT            is ${DOXY_COMPONENT}"
	@echo "DOXY_INPUT_DIR            is ${DOXY_INPUT_DIR}"
	@echo "DOXY_README               is ${DOXY_README}"
	@echo "DOXY_NUMBER               is ${DOXY_NUMBER}"
	@echo "DOXY_INCLUDE_DIRS         is ${DOXY_INCLUDE_DIRS}"
	@echo "DOXY_PREPROCESSOR_DEFINES is ${DOXY_PREPROCESSOR_DEFINES}"
	@echo "COMP_BIN_ROOT             is ${COMP_BIN_ROOT}"
	@echo "COMP_BIN_DIR              is ${COMP_BIN_DIR}"
	@echo "BIN_BUILT                 is ${BIN_BUILT}"
	@echo "COMP_LIB_ROOT             is ${COMP_LIB_ROOT}"
	@echo "COMP_LIB_DIR              is ${COMP_LIB_DIR}"
	@echo "COMP_OBJ_ROOT             is ${COMP_OBJ_ROOT}"
	@echo "COMP_OBJ_DIR              is ${COMP_OBJ_DIR}"
	@echo "C_INCLUDE_DIRS            is ${C_INCLUDE_DIRS}"
	@echo "C_PREPROCESSOR_DEFINES    is ${C_PREPROCESSOR_DEFINES}"
	@echo "CFLAGS                    is ${CFLAGS}"
	@echo "COMP_DEP_ROOT             is ${COMP_DEP_ROOT}"
	@echo "COMP_DEP_DIR              is ${COMP_DEP_DIR}"
	@echo "C_SRC_FILES               is ${C_SRC_FILES}"
	@echo "OBJ_FILES                 is ${OBJ_FILES}"
	@echo "DEP_FILES                 is ${DEP_FILES}"

# next, a target to generate documentation using Doxygen. note the
# doxygen command has a '-' in front of it. this allows the command
# to return an error and make will ignore it. for some reason, my
# installation of things is causing an error and i haven't figured
# it out yet. the documentation does get generated though...
docs:
	@echo ""
	@echo "makefile: generating Doxygen documentation"
	@echo "deleting docs directory at: ${DOXY_OUTPUT_DIR}"
	$(shell rm -rf ${DOXY_OUTPUT_DIR})
	@echo "creating docs directory at: ${DOXY_OUTPUT_DIR}"
	$(shell mkdir -p ${DOXY_OUTPUT_DIR})
	@echo "lastly, generating documentation"
	-$(shell DOXY_OUTPUT_DIR=${DOXY_OUTPUT_DIR} \
			 DOXY_NUMBER=${DOXY_NUMBER} \
			 DOXY_COMPONENT="${DOXY_COMPONENT}" \
			 DOXY_INPUT_DIR="${DOXY_INPUT_DIR}" \
			 DOXY_README="${DOXY_README}" \
			 DOXY_PREPROCESSOR_DEFINES="${DOXY_PREPROCESSOR_DEFINES}" \
			 DOXY_INCLUDE_DIRS="${DOXY_INCLUDE_DIRS}" \
			 ${DOXYGEN} ${DOXY_CONFIG} \
	  )
	@echo "makefile: done generating Doxygen documentation"

# once everything is loaded and configured, load the dependency
# files if they exist. first, make the dependencies files as
# PRECIOUS so they won't be deleted if make aborts.
.PRECIOUS: $(COMP_DEP_DIR)/%.d
$(COMP_DEP_DIR)/%.d: ;

-include $(DEP_FILES)
