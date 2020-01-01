/**
 * a.c contains the routine a() which is called by main().
 * 
 * this proves we can include object files from other
 * directories in the project.
 */

#include <stdlib.h>
#include <stdio.h>

#include "a.h"

int a();

int a() {
    printf("you called a()\n");

    return(0);
}