/**
 * @file b1.c
 * @brief an "external" object file included in b_lib.ar
 * @author Cliff Williams
 * 
 * @desc This file is an "external" object file that is linked into
 * the b_lib.arc archive. The archive is then linked to the hello 
 * executable.
 *
 * @bug no known bugs 
 */

#include <stdlib.h>
#include <stdio.h>

#include "b.h"

int b1();

/**
 * b1()  - function to add two constants and return the sum
 * 
 * @desc This is a "public" function called from @c main(). It adds
 * two constants and returns the sum.
 * 
 * @return the sum of MY_NUMBER_1 and my_number_2
 * 
 * @note This could have had a @c void return type. I was just feeling
 * lazy.
 */
int b1() {
    printf("b1(): calling b2()\n");
    int my_number_2 = b2();
    printf("b1(): returning %d + %d = %d\n", 
            MY_NUMBER_1,
            my_number_2,
            (MY_NUMBER_1 + my_number_2));
    return(MY_NUMBER_1 + my_number_2);
}
