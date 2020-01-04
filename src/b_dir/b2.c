/**
 * @file b2.c
 * @brief an "internal" object file included in b_lib.ar
 * @author Cliff Williams
 * 
 * @desc This file is an "internal" object file that is linked into
 * the b_lib.arc archive. The archive is then linked to the hello 
 * executable.
 *
 * @bug no known bugs 
 */

#include <stdlib.h>
#include <stdio.h>

#include "b.h"

int b2();

**
 * b2() - returns a constant
 * 
 * @desc This is an "internal" function called from @c b1(). It just
 * returns a constant.
 * 
 * @return the constant MY_NUMBER_2
 */
int b2() {
    printf("b2: returning %d\n", MY_NUMBER_2);
    return(MY_NUMBER_2);
}
