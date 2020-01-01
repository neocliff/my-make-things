build_system contains all the common tools and configuration files
used in building a project. The files are divided into two groups:

* build_library - things like make files or configuration files that
are shared by the entire project. if a component somewhere in the 
project requires a tailored version of one of these files and it 
can't be tailored using the standard mechanisms, it should then it
should have the tailored copy in the directory with the other 
component files.

* build_utilities - these are the shared scripts, utilities, etc.,
that are used by the project. in general, if it has '+x' in the
permissions, it probably belongs here.

what we are looking for is a division between what gets built
(i.e., build_library) vs. how a thing gets built (i.e.,
build_utilities). if you have ever done classical systems 
engineering, this is the application for a software-alone project.