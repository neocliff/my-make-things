# default.mk contains all the default definitions used in the 
# project, identify tools, etc.

SYS_BINDIR ?= /bin
USR_BINDIR ?= /usr/bin

# define all the default tools we use
CC		?= ${USR_BINDIR}/gcc
CXX		?= ${USR_BINDIR}/g++
LD		?= ${USR_BINDIR}/gold
TAR		?= ${SYS_BINDIR}/tar
AR		?= ${USR_BINDIR}/ar
