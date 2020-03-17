# t_dir and Component-Specific Values

This directory contains code that accesses component-specific information
in hello_cfg.h. This is modeling a problem I have encountered in a project at
the office.

We have a set of shared, libraries that need access to component-specific
information. The information is contained in structures, variables and
in `#define` values. At the time, I thought the number of components this would
apply to was limited to one. After poking at the codebase some more, there are
several.

Originally, I thought we could build the libraries in the subdirectory with the
source files. That won't work if I need a different build of library `x` for
components `a` and `b` and `c`.

Instead, I am going to do the build from the component that needs the library,
placing the object files with the ccomponent's source files.
