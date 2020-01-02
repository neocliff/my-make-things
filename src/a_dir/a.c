/**
 * a.c contains the routine a() which is called by main().
 * 
 * this proves we can include object files from other
 * directories in the project.
 */

#include <stdlib.h>
#include <stdio.h>

#include "a.h"
#include "a2.h"

int a();

int a() {
    printf("you called a()\n");
    printf("calling a2()\n");
    int a2_return = a2();
    printf("returned: %d\n", a2_return);

    return(0);
}