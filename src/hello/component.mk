# component.mk - component's description file

# this component results in a finished binary program so name it
BINBUILT = hello

# define the paths to the header files needed for this compoent
INC_DIR = ${I_AM_AT}/include

SRCS := hello.c

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
all: | $(BIN_DIR)/$(BINBUILT)