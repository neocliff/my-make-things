/**
 * @file hello_cfg.h
 * @author Cliff Williams (you@domain.com)
 * @brief Tests several Doxygen features and a make strategy
 * @version 0.1
 * @date 2020-03-15
 * 
 * @copyright Copyright (c) 2020 Cliff Williams
 */

#ifndef HELLO_CFG_H
#define HELLO_CFG_H

/**
 * @brief define the version of the program
 * 
 * Defines the version of the program using the standard:
 * major/minor/patch level/build number.
 * 
 * @note the build number is specified via a define in the makefile.
 * 
 * @note If you want the comments applied to a group of defines, use the 
 * syntax shown here **and** in your `Doxyfile`, set `DISTRIBUTE_GROUP_DOC` to `YES`.
 * If you don't, the comments will only apply to the first define/macro/variable
 * in the group.
 * 
 */
//@{
#define VERSION_MAJOR 1
#define VERSION_MINOR 0
#define VERSION_PATCH 50
//@}

/**
 * @brief defines the version information for this program
 * 
 */
typedef struct _my_version {
    int version_major;      //< major version number (0-999)
    int version_minor;      //< minor version number (0-999)
    int version_patch;      //< patch version number (0-999)
    int version_build;      //< build number (0-99999)
} MyVersion_t;

/**
 * @brief program version information
 * 
 * Declare the (externally visible) pointer to the structure containing the
 * version information. The pointer is initialized in @ref hello.c.
 */
extern MyVersion_t *my_version_ptr;

#endif // HELLO_CFG_H
