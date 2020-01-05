/**
 * @file a.c
 * @brief object file linked directly to hello program
 * @author Cliff Williams
 * 
 * This is an object file that is directly linked into the
 * hello program in src/hello. It proves we can link object files
 * from sibling directories.
 *
 * @bug no known bugs 
 */

#include <stdlib.h>
#include <stdio.h>

#include "a.h"
#include "a2.h"

int a();

/**
 * a()  - function to return a constant
 * 
 * This is a "public" function called from @c main().
 * 
 * @return 0 - meaning success
 * 
 * @note This could have had a @c void return type. I was just feeling
 * lazy.
 */
int a() {
    printf("you called a()\n");
    printf("calling a2()\n");
    int a2_return = a2();
    printf("returned: %d\n", a2_return);

    return(0);
}