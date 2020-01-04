/**
 * @file hello.h
 * @brief header file for hello program
 * @author Cliff Williams
 * 
 * @desc This is a header file used with the hello program.
 * This bit of code tests conditional compilation based on defines
 * indirectly set using the @c make command-line, like this...
 * 
 * @code
 * make ... ARCH_TYPE=x86_32 ... all
 * @endcode
 * 
 * which results in the following being set within compiler_rules.mk...
 * 
 * @code
 * CFLAGS += -DPROCESSOR_X86_32
 * @endcode
 * 
 * @bug no known bugs 
 */

#ifndef _hello_h
#define _hello_h

/**
 * define the BITSIZE based on the processor architecture
 */
#ifdef PROCESSOR_X86_32
#define BITSIZE 32
#elif PROCESSOR_X86_64
#define BITSIZE 64
#endif

#endif /* _hello_h */
