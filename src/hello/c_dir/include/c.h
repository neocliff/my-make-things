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

//#pragma GCC system_header
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
 */
#define MY_PRINT(s, ...) printf(s, ##__VA_ARGS__)

extern char *c();

#endif /* _c_h */
