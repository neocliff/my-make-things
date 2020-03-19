/**
 * @file c.h
 * @brief header file for c.c
 * @author Cliff Williams
 * 
 * This header file is used with hello/c_dir/c.c. 
 * 
 * @bug no known bugs 
 */

#ifndef _c_h
#define _c_h

#include <stdio.h>

/**
 * We are expiramenting with variadic argments in macros. The project at
 * the office uses them extensively. The problem is that they don't always
 * include an argument for the "..." part of the invocation. When compiling
 * with GCC -std=c11, things barf. The new C++2a (and I guess a C2a if they
 * it) fixes the problem. Or you can use the GNU extensions but I've been 
 * trying to avoid that.
 * 
 * Compile with '-std=c11' and get a warning;
 * Compile with '-std=gnu11' and get a warning
 *
 * The only way to avoid the warnings (for now) appears to be the nuclear option:
 * the 'system_header' pragma. Be warned though, using this makes GCC think this
 * is a system header file. It cause the compiler to dispense with most, maybe
 * all, of the warnings it would generate based on the command-line options. If
 * you have to use it, make the code as small as possible.
 */
#pragma GCC system_header
#define MY_PRINT(s, ...)    printf(s, ##__VA_ARGS__)

extern char *c();

#endif /* _c_h */
