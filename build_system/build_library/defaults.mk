# default.mk contains all the default definitions used in the 
# project, identify tools, etc.

SYS_BINDIR ?= /bin
USR_BINDIR ?= /usr/bin

# define all the default tools we use
CC		?= ${USR_BINDIR}/gcc
CXX		?= ${USR_BINDIR}/g++
LD		?= ${USR_BINDIR}/gold
TAR		?= ${SYS_BINDIR}/tar
AR		?= ${USR_BINDIR}/ar

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
DEP_DIR		?= $(DEP_ROOT)/$(BUILD_TYPE)/$(ARCH_TYPE)
OBJ_ROOT	?= ${I_AM_AT}/obj
OBJ_DIR		?= $(OBJ_ROOT)/$(BUILD_TYPE)/$(ARCH_TYPE)
BIN_ROOT	?= ${I_AM_AT}/bin
BIN_DIR		?= $(BIN_ROOT)/$(BUILD_TYPE)/$(ARCH_TYPE)
