/**
 * a2.c has a function that is called by a().
 */

#include <stdlib.h>
#include <stdio.h>

#include <a2.h>

int a2();

int a2() {
    printf("called a2()\n");
    printf("returning MY_CONSTANT: %d\n", MY_CONSTANT);
    return(MY_CONSTANT);
}