/**
 * toy header file defining a constant.
 */

#ifndef _hello_h
#define _hello_h

#ifdef PROCESSOR_X86_32
#define BITSIZE 32
#elif PROCESSOR_X86_64
#define BITSIZE 64
#endif

#endif /* _hello_h */
