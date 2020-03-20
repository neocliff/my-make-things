# default.mk contains all the default definitions used in the 
# project, identify tools, etc.

# define paths to system directories
SYS_BINDIR ?= /bin
USR_BINDIR ?= /usr/bin
GNU_BINDIR ?= ${USR_BINDIR}

# define all the default tools the project uses. note that we are
# using '=' rather than '?=' because GNU make defines several of these
# tools implicitly. the idea is you don't have to define them if you
# don't want to do so. we are defining them here to allow the project
# to use tools that are not in the standard locations.
CC		= ${GNU_BINDIR}/gcc
CXX     = ${GNU_BINDIR}/g++
AS      = ${GNU_BINDIR}/as

# use the new linker/loader called 'gold'. change it to 'ld' if
# 'gold' is causing problems. what i found on the web says it's a
# work-in-progress.
LD		= ${GNU_BINDIR}/ld.gold

# by default, GNU make defines CPP as '${CC} -E' which just runs the 
# C/C++ compiler's preprocessor. i prefer explcitly calling the
# compiler to run the preprocessor rather than use ${CPP} to do it.a
# i've reset the vaule to prevent confusion.
CPP     =

# define more useful tools
TAR		?= ${SYS_BINDIR}/tar
AR		?= ${GNU_BINDIR}/ar
STRIP   ?= ${USR_BINDIR}/strip
INSTALL ?= ${USR_BINDIR}/install

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
PROJ_SRC_SHARED ?= ${PROJ_SRC}/shared
PROJ_OBJ        ?= ${PROJ_ROOT}/obj
PROJ_OBJ_SHARED ?= ${PROJ_OBJ}/shared
PROJ_LIB        ?= ${PROJ_ROOT}/lib
PROJ_LIB_SHARED ?= ${PROJ_LIB}/shared
PROJ_DOXY_DOCS  ?= ${PROJ_ROOT}/doxy-docs

# define the default path for header files. unlike this such
# as the directory for obj files, the INCLUDE_DIRS is a list of
# directories that is scanned to locate header files. that
# means we could have multiple paths.
INCLUDE_DIRS ?= -I${I_AM_AT}/include

# define the default paths for everything else. these can be
# redefined in the component.mk files using something like the
# following syntax:
#		OBJDIR = my/obj/dir/path
COMP_DEP_ROOT	?= ${I_AM_AT}/dep
COMP_DEP_DIR	?= ${COMP_DEP_ROOT}/${BUILD_TYPE}/${ARCH_TYPE}
COMP_OBJ_ROOT	?= ${I_AM_AT}/obj
COMP_OBJ_DIR	?= ${COMP_OBJ_ROOT}/${BUILD_TYPE}/${ARCH_TYPE}
COMP_LIB_ROOT	?= ${I_AM_AT}/lib
COMP_LIB_DIR	?= ${COMP_LIB_ROOT}/${BUILD_TYPE}/${ARCH_TYPE}
COMP_BIN_ROOT	?= ${I_AM_AT}/bin
COMP_BIN_DIR	?= ${COMP_BIN_ROOT}/${BUILD_TYPE}/${ARCH_TYPE}

# create a few defaults for Doxygen document generation
DOXY_CONFIG     ?= ${BUILD_LIBRARY}/Doxyfile
DOXY_ROOT       ?= ${I_AM_AT}/doxy-docs
DOXY_OUTPUT_DIR ?= ${DOXY_ROOT}/${BUILD_TYPE}/${ARCH_TYPE}
DOXY_COMPONENT  ?= $(shell echo ${I_AM_AT} | \
						   sed -e 's,${PROJ_ROOT}/,,')
DOXY_INPUT_DIR  ?= ${I_AM_AT}
DOXY_README     ?= ${I_AM_AT}/README.md
DOXY_NUMBER     ?= $(shell git show --format="%h" --no-patch)
DOXY_PREPROCESSOR_DEFINES ?= ${PREPROCESSOR_DEFINES}
DOXY_INCLUDE_DIRS ?= ${INCLUDE_DIRS}

# define colors used in message output
ifeq ($(TERM),$(filter $(TERM),xterm screen xterm-color xterm-256color))
	ifdef USE_TPUT_COLOR
		# using the tput command to do text coloring
		COLOR_RED		= @tput setaf 1
		COLOR_GREEN		= @tput setaf 2
		COLOR_YELLOW	= @tput setaf 3
		COLOR_BLUE		= @tput setaf 4
		COLOR_MAGENTA	= @tput setaf 5
		COLOR_CYAN		= @tput setaf 6
		COLOR_NORMAL	= @tput sgr0
	else
		# using ansi escape codes to do text coloring
		COLOR_RED		= \033[31m
		COLOR_GREEN		= \033[32m
		COLOR_YELLOW	= \033[33m
		COLOR_BLUE		= \033[34m
		COLOR_MAGENTA	= \033[35m
		COLOR_CYAN		= \033[36m
		COLOR_NORMAL	= \033[0m
	endif
endif
