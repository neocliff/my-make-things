
# BUSYBOX OS 9.4ish and up, 64-bit Intel Westmere ISA. note that the ISA
# is dependent on the specific device being targeted. for example, the 
# 5515-X has an i3-540 CPU which is a Clarkdale, based on Westmere, based
# on Nahlem, based on Core 2. we are going to start with 'core2' but that
# may be a bad choice.

ifeq (${TARGET_TYPE},ASA_961)
	PROC_CLASS	= x86_64
endif