FROM ubuntu:18.04 AS base

# label history
#   u18.04v001 - with CMake 3.17
#   u18.04v002 - add Gradle 6.3, OpenJDK 11; removed CMake 3.17
#   u18.04v003 - removed Gradle 6.3, OpenJDK 11
#   u18.04v004 - upgrade to GCC 9.3.0, add graphviz
#	u18.04v005 - add pylint, googletest, lcov, gcovr
#	u18.04v006 - in process building from source
#	u18.04v007 - add pytest, turned off lcov, first multi-stage version
#   u18.04v008 - add splint, fixed some library issues (I hope)
#	u18.04v009 - fixed more library issues; resolved libstdc++.so.6 issue
#	u18.04v010 - multi-stage builds; requires DOCKER_BUILDKIT=1 in user
#				environment and `"buildkit":true` entry in the `features` list
#				in the /etc/docker/daemon.json file
#	u18.04v011 - delete `RUN id`; use --no-install-recommends; multi-stage
#				builds; removed several packages including sudo,
#				build-essential, g++multilib, git, curl, doxygen, graphviz

LABEL maintainer="neocliff@mac.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-utils ca-certificates wget libssl-dev \
        build-essential \
        g++-multilib automake autoconf \
        flex bison libtool-bin texinfo \
        git xz-utils libpcre3-dev \
		python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# define the directory for building/packaging the tools.

ARG build_dir=build_directory
WORKDIR /${build_dir}

# ####################################################### #
#                                                         #
# Download, configure, and install the tool packages.     #
#                                                         #
# ####################################################### #

#
# Build the artifacts for `gawk`.
#

FROM base AS gawk_bin

ARG gawk_v=5.0.1

RUN cd /${build_dir} \
	&& wget https://ftp.gnu.org/gnu/gawk/gawk-${gawk_v}.tar.xz \
    && tar -Jxf gawk-${gawk_v}.tar.xz
RUN cd gawk-${gawk_v} \
    && ./configure --prefix=/usr \
    && make -j$((`nproc`+1)) \
    && make DESTDIR=/${build_dir}/toolset install-strip

RUN cd /${build_dir} \
	&& tar cvfJ toolset.tar.xz toolset

#
# Build the artifacts for `binutils`.
#

FROM base AS binutils_bin

ARG binutils_v=2.34

RUN cd /$build_dir \
	&& wget https://ftp.gnu.org/gnu/binutils/binutils-${binutils_v}.tar.gz \
    && tar -xf binutils-${binutils_v}.tar.gz
RUN cd binutils-${binutils_v} \
    && ./configure --enable-targets=all \
		--enable-gold --enable-lto --enable-plugins \
		--prefix=/usr \
    && make  -j$((`nproc`+1)) \
    && make DESTDIR=/${build_dir}/toolset install-strip

RUN cd /${build_dir} \
	&& tar cvfJ toolset.tar.xz toolset

#
# Build the artifacts for `make`.
#

FROM base AS make_bin

ARG make_v=4.3

RUN cd /${build_dir} \
	&& wget https://ftp.gnu.org/gnu/make/make-${make_v}.tar.gz \
    && tar -zxf make-${make_v}.tar.gz
RUN cd make-${make_v} \
    && ./configure --prefix=/usr \
    && make -j$((`nproc`+1)) \
    && make DESTDIR=/${build_dir}/toolset install-strip

RUN cd /${build_dir} \
	&& tar cvfJ toolset.tar.xz toolset

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

FROM base AS gcc_bin

ARG gcc_v=9.3.0

RUN cd /${build_dir} \
	&& wget https://ftp.gnu.org/gnu/gcc/gcc-${gcc_v}/gcc-${gcc_v}.tar.xz \
    && tar -Jxf gcc-${gcc_v}.tar.xz
RUN mkdir gcc-${gcc_v}/build \
    && cd gcc-${gcc_v} \
    && ./contrib/download_prerequisites \
 	&& sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64 \
    && cd build \
    && ../configure --prefix=/usr --with-cpu-32=i686 --with-cpu-64=core2 \
        --enable-shared --enable-libstdcxx --enable-clocale=gnu \
        --with-multiarch --with-multilib-list=m32,m64 \
        --enable-languages=c,c++,lto \
        --enable-threads=posix \
        --enable-lto \
        --with-gnu-as -with-gnu-gold \
    && make -j$((`nproc`+1)) \
    && make DESTDIR=/${build_dir}/toolset install-strip

RUN cd /${build_dir} \
	&& tar cvfJ toolset.tar.xz toolset

# ########################## #
#                            #
# Add CPPCheck to container. #
#                            #
# ########################## #

FROM base AS cppcheck_bin

RUN cd /${build_dir} \
	&& wget https://github.com/danmar/cppcheck/archive/1.90.tar.gz \
    && tar xvf 1.90.tar.gz
RUN cd cppcheck-1.90 \
    && make MATCHCOMPILER=yes FILESDIR=/usr/share/cppcheck HAVE_RULES=yes CXXFLAGS="-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function" \
    && make FILESDIR=/usr/share/cppcheck DESTDIR=/${build_dir}/toolset install

RUN cd /${build_dir} \
	&& tar cvfJ toolset.tar.xz toolset

# #################################################################### #
#                                                                      #
# Final stage: Build the toolset Image.                                #
#                                                                      #
# #################################################################### #

FROM ubuntu:18.04 AS final

# define an argument which can be passed during build time
ARG UID=1000
ARG GID=1000

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		libtool-bin git \
		libpcre3-dev xz-utils \
		python3 python3-setuptools python3-pip \
	&& rm -rf /var/lib/apt/lists/*

#
# Load the artifacts from the "gawk_bin" stage.
#

COPY --from=gawk_bin /build_directory/toolset.tar.xz /tmp/toolset.tar.xz

RUN cd /tmp \
	&& tar -xvf toolset.tar.xz

RUN cp --recursive /tmp/toolset/* / \
	&& cd / \
	&& rm -rf /tmp/*

#
# Load the artifacts from the "binutils_bin" stage.
#

COPY --from=binutils_bin /build_directory/toolset.tar.xz /tmp/toolset.tar.xz

RUN cd /tmp \
	&& tar -xvf toolset.tar.xz

RUN cp --recursive /tmp/toolset/* / \
	&& cd / \
	&& rm -rf /tmp/*

#
# Load the artifacts from the "make_bin" stage.
#

COPY --from=make_bin /build_directory/toolset.tar.xz /tmp/toolset.tar.xz

RUN cd /tmp \
	&& tar -xvf toolset.tar.xz

RUN cp --recursive /tmp/toolset/* / \
	&& cd / \
	&& rm -rf /tmp/*

#
# Load the artifacts from the "gcc_bin" stage.
#

COPY --from=gcc_bin /build_directory/toolset.tar.xz /tmp/toolset.tar.xz

RUN cd /tmp \
	&& tar -xvf toolset.tar.xz

RUN cp --recursive /tmp/toolset/* / \
	&& cd / \
	&& rm -rf /tmp/*

#
# Load the artifacts from the "cppcheck_bin" stage.
#

COPY --from=cppcheck_bin /build_directory/toolset.tar.xz /tmp/toolset.tar.xz

RUN cd /tmp \
	&& tar -xvf toolset.tar.xz

RUN cp --recursive /tmp/toolset/* / \
	&& cd / \
	&& rm -rf /tmp/*

# need to relink libstdc++.so.6 because the installers don't seem to be doing
# it for us. checking on the internet shows people doing the same thing. grr!
RUN rm /usr/lib/x86_64-linux-gnu/libstdc++.so.6 \
	&& ln -s  /usr/lib64/libstdc++.so.6 /usr/lib/x86_64-linux-gnu/libstdc++.so.6

# final run of libtool to finish the 32- and 64-bit library installations.
RUN libtool --finish /usr/lib/../lib32 \
	&& libtool --finish /usr/lib/../lib

# add python modules we need
RUN pip3 install pylint pytest gcovr

# ################################################################ #
#                                                                  #
# Last steps... create a user account and give it sudo privileges. #
#                                                                  #
# ################################################################ #

RUN groupadd -g ${GID} user \
	&& useradd -rm -d /home/user -s /bin/bash -u ${UID} -g ${GID} user

# RUN echo "user ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/user
USER user

# Note that we are assigning a default working directory here. Normally, the
# container will be invoked with the option '--workdir /path/to/working/dir'
# to override the this. I did it this way because not everybody has the repo
# located in the same place and since we are mounting that directory in the
# container in the same place, this looked like the best option.

WORKDIR /home/user