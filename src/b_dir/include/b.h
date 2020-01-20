/**
 * @file b.h
 * @brief declares a prototypes and constants
 * @author Cliff Williams
 * 
 * This header file is used by b.c and b1.c and
 * externally by hello.c. It defines a couple of constants and
 * a couple of prototypes.
 * 
 * @bug no known bugs 
 */

#ifndef _b_h
#define _b_h

#define MY_NUMBER_1 100
#define MY_NUMBER_2 200

/**
 * MY_VA_MACRO() is a macro that accepts variadic arguments and turns themxi
 * into a printf() call.
 * 
 * In theory, the declaration below *should* support calls like
 *     MY_VA_MACRO("hello, world!\n")
 * It is a built-in behavior for GNU C.
 * 
 * @param s - control string
 * @param va_args - the '...' part that can be whatever the caller wants
 * @returns value returned by printf()
 */
#define MY_VA_MACRO(s, ...) printf(s, ##__VA_ARGS__ )

extern int b1();
extern int b2();

#endif
