FROM ubuntu:18.04

LABEL maintainer="neocliff@mac.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y \
	apt-utils wget sudo ssh libssl-dev \
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
# ARG cmake_ver=3.17.0
ARG gradle_ver=6.3

# ####################################################### #
#                                                         #
# Download, configure, and install the 'utility' packages #
#                                                         #
# ####################################################### #

# RUN wget https://github.com/Kitware/CMake/releases/download/v${cmake_ver}/cmake-${cmake_ver}.tar.gz \
#     && tar -xf /cmake-${cmake_ver}.tar.gz \
#     && cd /cmake-${cmake_ver} \
#     && ./bootstrap --prefix=/usr \
#     && make -j$((`nproc`+1)) \
#     && make install \
#     && cd / \
#     && rm -rf /cmake-${cmake_ver}*

# RUN wget https://ftp.gnu.org/gnu/m4/m4-${m4_v}.tar.xz \
#     && tar -Jxf m4-${m4_v}.tar.xz \
#     && cd /m4-${m4_v} \
#     && ./configure --prefix=/usr \
#     && make -j$((`nproc`+1)) \
#     && make install-strip \
#     && cd / \
#     && rm -rf /m4-${m4_v}*

# RUN wget https://ftp.gnu.org/gnu/sed/sed-${sed_v}.tar.xz \
#     && tar -Jxf sed-${sed_v}.tar.xz \
#     && cd /sed-${sed_v} \
#     && ./configure --prefix=/usr \
#     && make -j$((`nproc`+1)) \
#     && make install-strip \
#     && cd / \
#     && rm -rf /sed-${sed_v}*

RUN wget https://ftp.gnu.org/gnu/gawk/gawk-${gawk_v}.tar.xz \
    && tar -Jxf gawk-${gawk_v}.tar.xz \
    && cd /gawk-${gawk_v} \
    && ./configure --prefix=/usr \
    && make -j$((`nproc`+1)) \
    && make install-strip \
    && cd / \
    && rm -rf /gawk-${gawk_v}*

RUN wget http://ftp.gnu.org/gnu/binutils/binutils-${binutils_v}.tar.gz \
    && tar -xf /binutils-${binutils_v}.tar.gz \
    && cd /binutils-${binutils_v} \
    && ./configure --enable-targets=all --enable-gold --enable-lto --prefix=/usr \
    && make  -j$((`nproc`+1)) \
    && make install-strip \
    && cd / \
    && rm -rf /binutils-${binutils_v}*

RUN wget https://ftp.gnu.org/gnu/make/make-${make_v}.tar.gz \
    && tar -zxf make-${make_v}.tar.gz \
    && cd /make-${make_v} \
    && ./configure --prefix=/usr \
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
    && ../configure --prefix=/usr --with-cpu-32=i686 --with-cpu-64=core2 \
        --enable-shared --enable-libstdcxx --enable-clocale=gnu \
        --with-multiarch --with-multilib-list=m32,m64 \
        --enable-languages=c,c++,lto \
        --enable-threads=posix \
        --enable-lto \
        --with-gnu-as -with-gnu-gold \
    && make -j$((`nproc`+1)) \
    && make install-strip \
    && cd / \
    && rm -rf /gcc-${gcc_v}*

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

#RUN wget https://services.gradle.org/distributions/gradle-${gradle_ver}-bin.zip \
#    && unzip gradle-${gradle_ver}-bin.zip -d /opt \
#    && ln -s /opt/gradle-${gradle_ver} /opt/gradle \
#    && rm -f /gradle-${gradle_ver}*

# Add the gradle binaries to the path using Debian's alternatives system
#RUN update-alternatives --install "/usr/bin/gradle" "gradle" "/opt/gradle/bin/gradle" 1 \
#    && update-alternatives --set "gradle" "/opt/gradle/bin/gradle"

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
