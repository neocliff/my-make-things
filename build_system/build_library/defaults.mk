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

# use the new linker/loader called 'gold'. change it to 'ld' if
# 'gold' is causing problems. what i found on the web says it's a
# work-in-progress.
LD		= ${GNU_BINDIR}/gold

# set the default build type and architecture
BUILD_TYPE ?= debug
ARCH_TYPE  ?= x86_64

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
BIN_ROOT	?= ${I_AM_AT}/bin
BIN_DIR		?= $(BIN_ROOT)/${BUILD_TYPE}/${ARCH_TYPE}
