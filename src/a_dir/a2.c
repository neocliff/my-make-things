/**
 * @file a2.c
 * @brief object file linked directly to hello program
 * @author Cliff Williams
 * 
 * This is another object file that is directly linked into the
 * hello program in src/hello. It proves we can link object files
 * from sibling directories.
 * 
 * @note This code in this file is not directly called from hello.c
 * however the object file still has to be linked in via hello's 
 * <tt>component.mk</tt> file.
 *
 * @bug no known bugs 
 */

#include <stdlib.h>
#include <stdio.h>

#include "a2.h"

int a2();

/**
 * a2()  - A function called from a()
 * 
 * This is an interal call from a(). It just returns a constant
 * defined in a2.h.
 * 
 * @return the value of MY_CONSTANT
 */
int a2() {
    printf("called a2()\n");
    printf("returning MY_CONSTANT: %d\n", MY_CONSTANT);
    return(MY_CONSTANT);
}