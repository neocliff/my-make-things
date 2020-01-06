# default.mk contains all the default definitions used in the 
# project, identify tools, etc.

# define paths to system directories
SYS_BINDIR ?= /bin
USR_BINDIR ?= /usr/bin
GNU_BINDIR ?= ${USR_BINDIR}

# define all the default tools the project uses. note that we are
# using '=' rather than '?=' because GNU make defines several of these
# tools as defaults. the idea is you don't have to define them if you
# don't want to. we are defining them here to allow the project to
# use tools that are not in the standard locations.
CC		= ${GNU_BINDIR}/gcc
CXX		= ${GNU_BINDIR}/g++
TAR		= ${SYS_BINDIR}/tar
AR		= ${GNU_BINDIR}/ar
STRIP   = ${USR_BINDIR}/strip

# use the new linker/loader called 'gold'. change it to 'ld' if
# 'gold' is causing problems. what i found on the web says it's a
# work-in-progress.
LD		= ${GNU_BINDIR}/gold

# tool used to run Doxygen for generating documentation from source
DOXYGEN = ${USR_BINDIR}/doxygen

# set the default build type and architecture
BUILD_TYPE ?= debug
ARCH_TYPE  ?= x86_64

# sample pre-build step
PRE_BUILD = 

# standard post-build step. note that we are setting this step
# as a default to be used on all 'release' builds. if this isn't
# what is needed for a particular component, tailor it in the
# component.mk file.
POST_BUILD =
ifeq (${BUILD_TYPE},release)
POST_BUILD = ${BUILD_UTILITIES}/post_build_strip.sh
endif

# define the path to the project's src directory. this is needed if
# we need files that are not subordinate to ${I_AM_AT}. we also
# need to keep track of where the shared source code is kept. on
# some projects it is gathered components under a single 'shared'
# directory. a similar concept can be used for third-party source
# that is built into a library and then "installed" into a lib
# directory.
PROJ_SRC        ?= ${PROJ_ROOT}/src
PROJ_SRC_SHARED ?= ${PROJ_SRC}/src/shared
PROJ_LIB        ?= ${PROJ_ROOT}/lib
PROJ_LIB_SHARED ?= ${PROJ_LIB}/shared
DOXY_PUB_ROOT   ?= ${PROJ_ROOT}/doxy-docs

# define the default path for header files. unlike this such
# as the directory for obj files, the INC_DIR is a list of
# directories that is scanned to locate header files. that
# means we could have multiple paths.
INC_DIR ?= ${I_AM_AT}/include

# define the default paths for everything else. these can be
# redefined in the component.mk files using something like the
# following syntax:
#		OBJDIR = my/obj/dir/path
DEP_ROOT	?= ${I_AM_AT}/dep
DEP_DIR		?= $(DEP_ROOT)/${BUILD_TYPE}/${ARCH_TYPE}
OBJ_ROOT	?= ${I_AM_AT}/obj
OBJ_DIR		?= $(OBJ_ROOT)/${BUILD_TYPE}/${ARCH_TYPE}
LIB_ROOT	?= ${I_AM_AT}/lib
LIB_DIR		?= ${LIB_ROOT}/${BUILD_TYPE}/${ARCH_TYPE}
BIN_ROOT	?= ${I_AM_AT}/bin
BIN_DIR		?= $(BIN_ROOT)/${BUILD_TYPE}/${ARCH_TYPE}

# create a few defaults for Doxygen document generation
DOXY_CONFIG     ?= ${I_AM_AT}/Doxyfile
DOXY_ROOT       ?= ${I_AM_AT}/doxy-docs
DOXY_OUTPUT_DIR ?= ${DOXY_ROOT}/${BUILD_TYPE}/${ARCH_TYPE}
