# compiler_rules.mk - contains all the standard definitions of rules
#	to transform source into objects and libraries, and objects and
#	libraries into finished binaries.

# CFLAGS contains the default flags used to compile C code
CFLAGS = \
		-Wall \
		-pedantic

# DEPFLAGS contains the default flags given to the compiler to generate
# dependency files and targets. as much as i hate tricky stuff in
# makefiles, this is probably (and *only* probably) warranted. buyer
# beware!
#	-MT <target> - removes the default prefix directory components and
#		the suffix and applies the default object suffix
#	-MD - equivalent to '-M -MF <file>' except that -E is not implied.
#		in most cases this removes the directory components and the
#		source suffix and applies a '.d' suffix. this generates the
#		output dependency file as a side effect of the compilation stage.
#		ugh! note that using '-MMD' causes the dependency generator to
#		ignore system files. if you have a really large project, you 
#		might want to use that instead.
#	-MP - creates a PHONY target for each dependency other that the main
#		file, cause each to depend on nothing. these dummy rules get 
#		around errors make generates if you remove header files without
#		updating the make file.
#	-MF <target> - specifies the name of the file to send the dependencies.
#		without this switch, the output is sent to the same place it
#		would send the preprocessor output. this overrides the default
#		file name generated by '-MD' and '-MMD'. it will only generate
#		dependencies for the project header files.
#
#	note: this was set to generate dependencies on project and sytem
#		header files. this behavior is set by the '-MD' switch. you might
#		want this if you are figure out x86_32 vs. x86_64 issues. if this
#		becomes unweildy, use the '-MMD' switch instead.
DEPFLAGS = -MT $@ -MD -MP -MF $(DEPDIR)/$*.Td

# we are going to define some compiler rules. i wouldn't normally do it
# this way but the example i'm using does. if you don't like this, break
# if for your specific project.
COMPILE.c = $(CC) -I$(INCDIR) $(DEPFLAGS) $(CFLAGS) -c -o $@

# use this command to save the dependencies files.
SAVE.d = mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d

# default linking rule to build the program binary identified in
# $(BINDIR)/$(BINBUILT) and composed of the objects in $(OBJS).
$(BINDIR)/$(BINBUILT): $(OBJS)
	@echo ""
	@echo "makefile: linking '$(BINDIR)/$(BINBUILT)' from '$(OBJS)'"
	$(CC) -o $(BUILDIR)/$(BINBUILT) $(OBJS)

# default compilation rule to turn a '.c' file into a '.o'
$(OBJDIR)/%.o: %.c
$(OBJDIR)/%.o: %.c $(DEPDIR)/%.d
	@echo ""
	@echo "makefile: compiling '$@' from '$<'"
	$(COMPILE.c) $<
	@echo "makefile: moving dependency file to $(DEPDIR)/$*.d"
	$(SAVE.d)

