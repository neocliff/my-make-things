/**
 * @file s.c
 * @author Cliff Williams
 * @brief Sample of versioned/dated library
 * @version 0.1
 * @date 2020-03-19
 * 
 * @copyright Copyright (c) 2020 Cliff Williams
 * 
 * This is a part of a "versioned" or "dated" library. This experiment is 
 * accessing a shared variable from the "hello" part. Specifically, we are
 * going to get the my_version_ptr and use it to build a version string.
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "s.h"
#include "hello_cfg.h"

/**
 * @brief Size of version_string buffer in bytes
 * 
 * @note Assumes we are using simple ASCII characters, not wide characters
 */
#define VER_STR_SIZE    20

/**
 * @brief memory initialization byte
 *
 * define the memory initialization byte (usually 0). this is used with
 * routines like memset() to initize strings or memory regions. 
 */
#define INIT_BYTE       0

/**
 * @brief Returns a canned integer
 * 
 * @return channed integer corresponding to the "date" of this library
 */
int s() {
    return(200105);
}

/**
 * @brief Returns version information as a string
 * 
 * The s_version() function returns the program vers   ion information in the
 * traditional 4-ple: "major.minor.patch.build". Assume a max of 3 digits for
 * major, minor, and patch, and a max of 5 digits for build, plus 3 dots and
 * the trailing null, means we need a buffer with (at least) 18 bytes.
 * 
 * @note The buffer is a static char array within this function.
 * 
 * @return char* ptr to string with version information
 */
char *s_version() {
    /* declare the string buffer and initialize it to INIT_BYTE */
    static char version_string[VER_STR_SIZE];
    memset(version_string, INIT_BYTE, VER_STR_SIZE);

    /* format the string and write it to the buffer */
    int bytes_written = snprintf(version_string,
                                 VER_STR_SIZE,
                                 "%d.%d.%03d.%05d",
                                 my_version_ptr->version_major,
                                 my_version_ptr->version_minor,
                                 my_version_ptr->version_patch,
                                 my_version_ptr->version_build);
    
    /* verify we didn't write more bytes than will fit in the buffer */
    if (bytes_written > VER_STR_SIZE) {
        printf("error: overwrote the version_string buffer (%d > %d\n",
               bytes_written, VER_STR_SIZE);
        return(NULL);
    }

    printf("debug: version_string: %s\n", version_string);

    /* return string ptr to caller */
    return(version_string);
}