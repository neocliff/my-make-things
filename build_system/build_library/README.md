build_library - things like make files or configuration files that
are shared by the entire project. if a component somewhere in the 
project requires a tailored version of one of these files and it 
can't be tailored using the standard mechanisms, it should then it
should have the tailored copy in the directory with the other 
component files.

as a rule, if the file has '+x' in the permissions, it belongs in
build_utilities. otherwise, this is the right place for it.