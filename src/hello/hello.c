/**
 * @file hello.c
 * @brief typical "hello world!" code enhanced for this project
 * @author Cliff Williams
 * 
 * @desc This is a typical "Hello, world!" program this project.
 * The code is contrived to demonstrate various capabilities of the
 * build system. As such, it doesn't do anything gee-wiz.
 * 
 * I am also using the C code in this project to provide standards
 * for documentation on a project for work. Feel free to toss them
 * out if you don't like them. I know Doxygen isn't everyone's
 * cup-of-tea!
 * ~Cliff
 *
 * @bug no known bugs 
 */

#include <stdlib.h>
#include <stdio.h>

#include "hello.h"
#include "c.h"
#include "a.h"
#include "b.h"

int main (int argc, char *argv[], char *envp[]);

/**
 * main() - The main() for the hello program.
 * 
 * @desc This is just like every other program's main() function.
 * 
 * @param[in] argc the number of CLI arguments
 * @param[in] argv the CLI arguments
 * @param[in] envp the environment strings
 * @return 0 - meaning success
 */
int main (int argc, char *argv[], char *envp[]) {
    printf("hello, world!\n");

    /**
     * this next line checks conditional compilation
     * based on CLI argument to make */
    printf("built for BITSIZE: %d\n", BITSIZE);

    /**
     * call made to function (a()) in object file in src/a_dir which is
     * a sibling directory to src/hello 
     */
    printf("calling a()...\n");
    a();
    printf("back in main()\n");

    /**
     * now test making a call to b1(), a function in a library in
     * src/b_dir which is also a sibling directory
     */
    int b_res = b1();
    printf("called b1(), result is %d\n", b_res);

    printf("calling c()...\n");
    printf("got: %s\n", c());
    printf("done with c()\n");

    /**
     * all done; return success
     */
    return(0);
}