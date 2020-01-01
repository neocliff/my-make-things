/**
 * hello.c - typical "hello world!" code enhanced for this project
 */

#include <stdlib.h>
#include <stdio.h>

#include "hello.h"

int main (int, char **, char **);

int main (int argc, char *argv[], char *envp[]) {
    printf("hello, world!\n");
    printf("built for BITSIZE: %d\n", BITSIZE);

    return(0);
}