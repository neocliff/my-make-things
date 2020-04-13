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
 * with GCC -std=c11, things barf. When compiled with -std=gnu11, no warning
 * is generated.
 */
#define MY_PRINT(s, ...)    printf(s, ##__VA_ARGS__)

extern char *c();

#endif /* _c_h */
