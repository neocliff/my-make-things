

#include <stdlib.h>
#include <stdio.h>

#include "b.h"

int b1();

int b1() {
    printf("b1(): calling b2()\n");
    int my_number_2 = b2();
    printf("b1(): returning %d + %d = %d\n", 
            MY_NUMBER_1,
            my_number_2,
            (MY_NUMBER_1 + my_number_2));
    return(MY_NUMBER_1 + my_number_2);
}
