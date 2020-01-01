# before anything define the shell
SHELL = /bin/shell

# figure out where i'm located
I_AM_AT = $(shell pwd)

# building toward the insane complexity of the main project,
# supply a default BUILD_TYPE and ARCH_TYPE in case the user
# doesn't give it to us
BUILD_TYPE ?= debug
ARCH_TYPE  ?= x86_64

# this file defines what we are building. in particular, we
# need the list of source modules that make up the component.
include component.mk

.PHONY: all checkit clean
.default: all

# define the standard paths for headerfiles. unlike this such
# as the directory for obj files, the INCDIR is a list of
# directories that is scanned to locate header files. that
# means we could have multiple paths.
INCDIR ?= include

# define the standard paths for everything else. these can be
# redefined in the component.mk files using something like the
# following syntax:
#		OBJDIR = my/obj/dir/path
DEP_ROOT	?= dep
DEPDIR		?= $(DEP_ROOT)/$(BUILD_TYPE)/$(ARCH_TYPE)
OBJ_ROOT	?= obj
OBJDIR		?= $(OBJ_ROOT)/$(BUILD_TYPE)/$(ARCH_TYPE)
BIN_ROOT	?= bin
BINDIR		?= $(BIN_ROOT)/$(BUILD_TYPE)/$(ARCH_TYPE)

# this rule produces a set of object files that make up the
# binary defined in $(BINBUILT). this list of object files is
# built in two parts:
#	1. for each file in $(SRCS), change the .c to a .o suffix
#	2. for each object file, prepend '$(BINDIR)/' in front
#		of the file name
OBJS = $(addprefix $(OBJDIR)/,$(SRCS:.c=.o))

# in a similar fashion, make the include/header dependencies
DEPS = $(addprefix $(DEPDIR)/,$(SRCS:.c=.d))

# auto-build the directories we need. there are lots of ways
# to do this. this is brute-force but it always works. note
# the creation of the BINDIR directory is different from that
# for the objects and dependencies. that later two preserve
# intermediate directories (e.g., a/b/c.o gets us obj/a/b)
# while the first is just a path to a directory. it can be
# changed to behave the same as the other two if BIN (or BINS)
# has a path and not just a file name.
$(shell mkdir -p $(BINDIR) > /dev/null)
$(shell mkdir -p $(dir $(OBJS)) > /dev/null)
$(shell mkdir -p $(dir $(DEPS)) > /dev/null)

# pull in the definition of the compiler rules, a generic set
# of recipes that tell make how to transform x.y -> x.z
include compiler_rules.mk

# this is the target that does it all. the ordered list of
# dependencies (the list of things after the '|') has to be
# built in order...
#	1. create target directories that doen't already exist
#	2. make the final binary as a target
all: | $(BINDIR)/$(BINBUILT)

# this is the target when we want to roll everything back to
# the prebuild state (i.e., we just checked the code out of
# the repo)
clean:
	rm -rf $(DEPDIR)
	rm -rf $(OBJDIR)
	rm -rf $(BINDIR)

cleanall:
	rm -rf $(DEP_ROOT)
	rm -rf $(OBJ_ROOT)
	rm -rf $(BIN_ROOT)

# this is the target that dumps variables so that we can check
# the build process.
checkit:
	@echo "BUILD_TYPE is $(BUILD_TYPE)"
	@echo "ARCH_TYPE is $(ARCH_TYPE)"
	@echo "BINBUILT is $(BINBUILT)"
	@echo "OBJ_ROOT is $(OBJ_ROOT)"
	@echo "OBJDIR is $(OBJDIR)"
	@echo "INCDIR is $(INCDIR)"
	@echo "DEP_ROOT is $(DEP_ROOT)"
	@echo "DEPDIR is $(DEPDIR)"
	@echo "SRCS is $(SRCS)"
	@echo "OBJS is $(OBJS)"
	@echo "INCLUDES is $(INCLUDES)"
	@echo "DEPS is $(DEPS)"

# make the dependencies files PRECIOUS so they won't be deleted
# if make aborts
.PRECIOUS: $(DEPDIR)/%.d
$(DEPDIR)/%.d: ;

-include $(DEPS)
