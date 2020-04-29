# syntax = docker/dockerfile:1.0-experimental
# TODO: do we still need the 'syntax' line?

FROM ubuntu:18.04 AS builder

# label history
#   u18.04v001 - with CMake 3.17
#   u18.04v002 - add Gradle 6.3, OpenJDK 11; removed CMake 3.17
#   u18.04v003 - removed Gradle 6.3, OpenJDK 11
#   u18.04v004 - upgrade to GCC 9.3.0, add graphviz
#	u18.04v005 - add pylint, googletest, lcov, gcovr
#	u18.04v006 - in process building from source
#	u18.04v007 - add pytest, turned off lcov, first multi-stage version
#   u18.04v008 - add splint, fixed some library issues (I hope)

LABEL maintainer="neocliff@mac.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y \
        apt-utils wget libssl-dev \
        build-essential \
        g++-multilib automake autoconf \
        flex bison libtool-bin texinfo \
        git xz-utils \
    && rm -rf /var/lib/apt/lists/*

# define the directory for building/packaging the tools.

ARG build_dir=build_directory
WORKDIR /${build_dir}

# ####################################################### #
#                                                         #
# Download, configure, and install the 'utility' packages #
#                                                         #
# ####################################################### #

# ARG m4_v=1.4.18

# RUN wget https://ftp.gnu.org/gnu/m4/m4-${m4_v}.tar.xz \
#     && tar -Jxf m4-${m4_v}.tar.xz \
#     && cd /m4-${m4_v} \
#     && ./configure --prefix=/usr \
#     && make -j$((`nproc`+1)) \
#     && make install-strip \
#     && cd / \
#     && rm -rf /m4-${m4_v}*

# ARG sed_v=4.8

# RUN wget https://ftp.gnu.org/gnu/sed/sed-${sed_v}.tar.xz \
#     && tar -Jxf sed-${sed_v}.tar.xz \
#     && cd /sed-${sed_v} \
#     && ./configure --prefix=/usr \
#     && make -j$((`nproc`+1)) \
#     && make install-strip \
#     && cd / \
#     && rm -rf /sed-${sed_v}*

ARG gawk_v=5.0.1

RUN cd /${build_dir} \
	&& wget https://ftp.gnu.org/gnu/gawk/gawk-${gawk_v}.tar.xz \
    && tar -Jxf gawk-${gawk_v}.tar.xz
RUN cd gawk-${gawk_v} \
    && ./configure --prefix=/usr \
    && make -j$((`nproc`+1)) \
    && make DESTDIR=/${build_dir}/toolset install-strip

ARG binutils_v=2.34

RUN cd /$build_dir \
	&& wget https://ftp.gnu.org/gnu/binutils/binutils-${binutils_v}.tar.gz \
    && tar -xf binutils-${binutils_v}.tar.gz
RUN cd binutils-${binutils_v} \
    && ./configure --enable-targets=all --enable-gold --enable-lto --prefix=/usr \
    && make  -j$((`nproc`+1)) \
    && make DESTDIR=/${build_dir}/toolset install-strip

ARG make_v=4.3

RUN cd /${build_dir} \
	&& wget https://ftp.gnu.org/gnu/make/make-${make_v}.tar.gz \
    && tar -zxf make-${make_v}.tar.gz
RUN cd make-${make_v} \
    && ./configure --prefix=/usr \
    && make -j$((`nproc`+1)) \
    && make DESTDIR=/${build_dir}/toolset install-strip

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

# ############################################################ #
#                                                              #
# Install Gradle binaries. It is positioned here just in case  #
# we have to build Gradle from source code rather than install #
# the binaries.                                                #
#                                                              #
# ############################################################ #

#                            NOTES
# 1. We need to install 'unzip' to decompress the gradle-*.zip file.
#    In certain circumstances, 'gzip' can decompress a .zip file but
#    the Gradle .zip file does not meet the requirements.
# 2. Gradle 6.3 supports OpenJDK 14. Ghidra appears to support
#    OpenJDK 14 however the Installation Guide still says OpenJDK 11.
#    I can't think of a reason why we would put Ghidra in a Docker
#    container, for now stick with OpenJDK 11 because that will be
#    on our dev instances.

# ARG gradle_ver=6.3

# RUN wget https://services.gradle.org/distributions/gradle-${gradle_ver}-bin.zip \
#    && unzip gradle-${gradle_ver}-bin.zip -d /opt \
#    && ln -s /opt/gradle-${gradle_ver} /opt/gradle \
#    && rm -f /gradle-${gradle_ver}*

# Add the gradle binaries to the path using Debian's alternatives system
# RUN update-alternatives --install "/usr/bin/gradle" "gradle" "/opt/gradle/bin/gradle" 1 \
#    && update-alternatives --set "gradle" "/opt/gradle/bin/gradle"

# #########################################
#                                         #
# Build Google Test and associated tools. #
#                                         #
# #########################################

#                             NOTE
# we don't need this if `gcovr` provides adequate reports

# RUN apt-get update \
# 	&& apt-get install -y libjson-perl libperlio-gzip-perl \
# 	&& rm -rf /var/lib/apt/lists/*

# RUN git clone https://github.com/linux-test-project/lcov /lcov \
# 	&& cd /lcov \
# 	&& make install \
# 	&& cd / \
# 	&& rm -rf /lcov*

#                           NOTE
# Download and build CMake just for Google Test. Note that when we do the
# `make install`, we are not installing it to `/${build_dir}` directory.
# That is because we are *not* carrying the tool into future stages.

ARG cmake_ver=3.17.0

RUN wget https://github.com/Kitware/CMake/releases/download/v${cmake_ver}/cmake-${cmake_ver}.tar.gz \
    && tar -xf cmake-${cmake_ver}.tar.gz
RUN cd cmake-${cmake_ver} \
    && ./bootstrap --prefix=/usr \
    && make -j$((`nproc`+1)) \
    && make install

RUN cd /${build_dir} \
	&& git clone https://github.com/google/googletest.git googletest \
	&& mkdir googletest/gtest_build \
	&& cd googletest/gtest_build \
	&& cmake .. \
	&& make -j$((`nproc`+1)) \
	&& make DESTDIR=/${build_dir}/toolset install

# ########################## #
#                            #
# Build the splint binaries. #
#                            #
# ########################## #

RUN cd /${build_dir} \
	&& git clone https://github.com/splintchecker/splint.git splint \
	&& cd splint \
	&& ./bootstrap \
	&& ./configure --prefix=/usr \
    && make -j$((`nproc`+1)) \
	&& make -j$((`nproc`+1)) check \
    && make DESTDIR=/${build_dir}/toolset install-strip

# #################################### #
#                                      #
# Build the artifacts from this stage. #
#                                      #
# #################################### #

# RUN cd /${build_dir} \
# 	&& find toolset -type f | xargs strip -g | 2> /dev/null
RUN cd /${build_dir} \
	&& tar cvfJ toolset.tar.xz toolset

# ##################################### #
#                                       #
# Final stage: Build the toolset Image. #
#                                       #
# ##################################### #

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y \
        apt-utils curl sudo \
        build-essential \
        g++-multilib \
        flex bison libtool-bin texinfo \
        git doxygen graphviz \
        python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /build_directory/toolset.tar.xz /tmp/toolset.tar.xz

RUN cd /tmp \
	&& tar -xvf toolset.tar.xz

RUN sudo cp --recursive /tmp/toolset/* / \
	&& cd / \
	&& rm -rf /tmp/*

# need to relink libstdc++.so.6 because the installers don't seem to be doing
# it for us. checking on the internet shows people doing the same thing. grr!
# RUN sudo rm /usr/lib/x86_64-linux-gnu/libstdc++.so.6 \
#	&& sudo ln -s  /usr/lib64/libstdc++.so.6 /usr/lib/x86_64-linux-gnu/libstdc++.so.6

# final run of libtool to finish the 32- and 64-bit library installations.
RUN sudo libtool --finish /usr/lib/../lib32 \
	&& sudo libtool --finish /usr/lib/../lib64

# add python modules we need
RUN pip3 install pylint pytest gcovr

# ################################################################ #
#                                                                  #
# Last steps... create a user account and give it sudo privileges. #
#                                                                  #
# ################################################################ #

RUN useradd -rm -d /home/user -s /bin/bash -u 1000 user
RUN echo "user ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/user
USER user

# Note that we are assigning a default working directory here. Normally, the
# container will be invoked with the option '--workdir /path/to/working/dir'
# to override the this. I did it this way because not everybody has the repo
# located in the same place and since we are mounting that directory in the
# container in the same place, this looked like the best option.

WORKDIR /home/user
