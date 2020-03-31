FROM ubuntu:18.04

LABEL maintainer="neocliff@mac.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y \
        wget sudo ssh \
        build-essential \
        g++-multilib \
        flex bison libtool texinfo \
        git xz-utils doxygen \
        python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# ############################## #
#                                #
# Define package version numbers #
#                                #
# ############################## #

ARG binutils_v=2.34
ARG gawk_v=5.0.1
ARG gcc_v=9.2.0
ARG m4_v=1.4.18
ARG make_v=4.3
ARG sed_v=4.8

# ####################################################### #
#                                                         #
# Download, configure, and install the 'utility' packages #
#                                                         #
# ####################################################### #

# RUN wget https://ftp.gnu.org/gnu/m4/m4-${m4_v}.tar.xz \
#     && tar -Jxf m4-${m4_v}.tar.xz \
#     && cd /m4-${m4_v} \
#     && ./configure \
#     && make -j$((`nproc`+1)) \
#     && make install-strip \
#     && cd / \
#     && rm -rf /m4-${m4_v}*

# RUN wget https://ftp.gnu.org/gnu/sed/sed-${sed_v}.tar.xz \
#     && tar -Jxf sed-${sed_v}.tar.xz \
#     && cd /sed-${sed_v} \
#     && ./configure \
#     && make -j$((`nproc`+1)) \
#     && make install-strip \
#     && cd / \
#     && rm -rf /sed-${sed_v}*

RUN wget https://ftp.gnu.org/gnu/gawk/gawk-${gawk_v}.tar.xz \
    && tar -Jxf gawk-${gawk_v}.tar.xz \
    && cd /gawk-${gawk_v} \
    && ./configure \
    && make -j$((`nproc`+1)) \
    && make install-strip \
    && cd / \
    && rm -rf /gawk-${gawk_v}*

RUN wget http://ftp.gnu.org/gnu/binutils/binutils-${binutils_v}.tar.gz \
    && tar -xf /binutils-${binutils_v}.tar.gz \
    && cd /binutils-${binutils_v} \
    && ./configure --enable-targets=all --enable-gold --enable-lto \
    && make \
    && make install-strip \
    && cd / \
    && rm -rf /binutils-${binutils_v}*

RUN wget https://ftp.gnu.org/gnu/make/make-${make_v}.tar.gz \
    && tar -zxf make-${make_v}.tar.gz \
    && cd /make-${make_v} \
    && ./configure \
    && make -j$((`nproc`+1)) \
    && make install-strip \
    && cd / \
    && rm -rf /make-${make_v}*

# ########################################################### #
#                                                             #
# And now, download, configure and install gcc. note that gcc #
# runs a script called download_prerequisites that pulls down #
# the libraries that are needed to build gcc. we don't have   #
# to pull them down and build them beforehand. in fact, you   #
# will likely have errors if you do it outside of the gcc     #
# build process.                                              #
#                                                             #
# ########################################################### #

RUN wget https://ftp.gnu.org/gnu/gcc/gcc-${gcc_v}/gcc-${gcc_v}.tar.xz \
    && tar -Jxf gcc-${gcc_v}.tar.xz \
    && mkdir /gcc-${gcc_v}/build \
    && cd /gcc-${gcc_v} \
    && ./contrib/download_prerequisites \
    && cd build \
    && ../configure --with-cpu-32=i686 --with-cpu-64=core2 \
        --with-multiarch --with-multilib-list=m32,m64 \
        --enable-languages=c,c++,lto \
        --enable-threads=posix \
        --enable-lto \
        --with-gnu-as -with-gnu-gold \
    && make -j$((`nproc`+1)) \
    && make install-strip \
    && cd / \
    && rm -rf /gcc-${gcc_v}*

# ################################### #
#                                     #
# Last steps... create a user account #
# and give it sudo privileges         #
#                                     #
# ################################### #

RUN useradd -rm -d /home/user -s /bin/bash -u 1000 user
RUN echo "user ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/user
USER user

# Note that we are assigning a default working directory here. Normally, the
# container will be invoked with the option '--workdir /path/to/working/dir'
# to override the this. I did it this way because not everybody has the repo
# located in the same place and since we are mounting that directory in the
# container in the same place, this looked like the best option.
WORKDIR /home/user
