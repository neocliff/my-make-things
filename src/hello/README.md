# src/hello README File

This isn't the most amazing code but it accomplishes a purpose: prove the build
system works and experiment with certain C constructs.

* variadic arguments for macro -  This is an issue I'm encountering at work.
We inherited some code from another team that uses variadic arguments in macro
calls. They work fine unless you don't supply at least one argument. In that
case, GCC complains loudly that C99 requires a diagnostic message. GNU says you
can disable the message but all the usual ways don't seem to work. Even GNU-centric
things like using `, ##__VA_ARGS__` don't seem to work.
