/**
 * @file c.c
 * @brief object file linked directly to hello program
 * @author Cliff Williams
 * 
 * This is a file in a sub-directory to src/hello. The point
 * of this file is to prove the build system can handle subdirectories
 * in a component.
 *
 * @bug no known bugs 
 */

#include <stdlib.h>
#include <stdio.h>

#include "c.h"

char * c();

/**
 * c()  - get a pointer to a static string
 * 
 * This is an internal function to the hello component. It is
 * demonstrating a subdirectory to a component.
 * 
 * @return ptr to the character string
 */
char *c() {
    static char *c_string = "This is a string from c().";
    return(c_string);
}