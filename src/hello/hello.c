/**
 * hello.c - typical "hello world!" code enhanced for this project
 */

#include <stdlib.h>
#include <stdio.h>

#include "hello.h"
#include "a.h"
#include "b.h"

int main (int, char **, char **);

int main (int argc, char *argv[], char *envp[]) {
    printf("hello, world!\n");
    printf("built for BITSIZE: %d\n", BITSIZE);
    printf("calling a()...\n");
    a();
    printf("back in main()\n");
    int b_res = b1();
    printf("called b1(), result is %d\n", b_res);
    return(0);
}