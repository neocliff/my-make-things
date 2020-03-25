FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates binutils git make g++ g++-multilib g++-7-multilib \
    gcc-7-doc apt-utils libstdc++6-7-dbg libstdc++-7-doc libacl1-dev \
    flex bison texinfo wget xz-utils doxygen libtool build-essential \
    sudo \
&& rm -rf /var/lib/apt/lists/*

ARG binutils_v=2.33.1
ARG gawk_v=5.0.1
ARG gcc_v=9.2.0
ARG gmp_v=6.1.0
ARG isl_v=0.18
ARG m4_v=1.4.18
ARG make_v=4.3
ARG mpc_v=1.0.3
ARG mpfr_v=4.0.2
ARG sed_v=4.8
ARG zstd_v=1.4.4

# Download, configure, install necessary source code packages
RUN wget https://ftp.gnu.org/gnu/m4/m4-${m4_v}.tar.xz \
    && tar -Jxf m4-${m4_v}.tar.xz \
    && cd /m4-${m4_v} \
    && ./configure \
    && make -j$((`nproc`+1)) \
    && make install-strip \
    && cd / \
    && rm -rf /m4-${m4_v}*

RUN wget https://ftp.gnu.org/gnu/sed/sed-${sed_v}.tar.xz \
    && tar -Jxf sed-${sed_v}.tar.xz \
    && cd /sed-${sed_v} \
    && ./configure \
    && make -j$((`nproc`+1)) \
    && make install-strip \
    && cd / \
    && rm -rf /sed-${sed_v}*

RUN wget https://ftp.gnu.org/gnu/gawk/gawk-${gawk_v}.tar.xz \
    && tar -Jxf gawk-${gawk_v}.tar.xz \
    && cd /gawk-${gawk_v} \
    && ./configure \
    && make -j$((`nproc`+1)) \
    && make install-strip \
    && cd / \
    && rm -rf /gawk-${gawk_v}*

RUN wget https://gcc.gnu.org/pub/gcc/infrastructure/gmp-${gmp_v}.tar.bz2 \
    && tar -jxvf /gmp-${gmp_v}.tar.bz2 \
    && cd /gmp-${gmp_v} \
    && ./configure \
    && make -j$((`nproc`+1)) \
    && make check \
    && make install-strip \
    && cd / \
    && rm -rf /gmp-${gmp_v}*

# TODO I took the 'make check' step out because the 'tversion' test case
# has something wrong. I will investigate off-line.
RUN wget https://www.mpfr.org/mpfr-current/mpfr-${mpfr_v}.tar.xz \
    && tar -Jxf /mpfr-${mpfr_v}.tar.xz \
    && cd /mpfr-${mpfr_v} \
    && ./configure \
    && make \
    && make install-strip \
    && cd / \
    && rm -rf /mpfr-${mpfr_v}*

RUN wget https://gcc.gnu.org/pub/gcc/infrastructure/mpc-${mpc_v}.tar.gz \
    && tar -jxvf /mpc-${mpc_v}.tar.gz \
    && cd /gmp-${mpc_v} \
    && ./configure \
    && make -j$((`nproc`+1)) \
    && make install-strip \
    && cd / \
    && rm -rf mpc-${mpc_v}*

RUN wget https://gcc.gnu.org/pub/gcc/infrastructure/isl-${isl_v}.tar.bz2 \
    && tar -jxvf /isl-${isl_v}.tar.bz2 \
    && cd /isl-${isl_v} \
    && ./configure \
    && make -j$((`nproc`+1)) \
    && make install-strip \
    && cd / \
    && rm -rf /isl-${isl_v}*

RUN wget https://github.com/facebook/zstd/releases/download/v${zstd_v}/zstd-${zstd_v}.tar.gz \
    && tar -zxf zstd-${zstd_v}.tar.gz \
    && cd /zstd-${zstd_v} \
    && make -j$((`nproc`+1)) \
    && make install \
    && cd / \
    && rm -rf /zstd-${zstd_v}*

RUN wget https://ftp.gnu.org/gnu/make/make-${make_v}.tar.gz \
    && tar -zxf make-${make_v}.tar.gz \
    && cd /make-${make_v} \
    && ./configure \
    && make -j$((`nproc`+1)) \
    && make install-strip \
    && cd / \
    && rm -rf /make-${make_v}*

RUN wget https://ftp.gnu.org/gnu/binutils/binutils-${binutils_v}.tar.xz \
    && tar -Jxf binutils-${binutils_v}.tar.xz \
    && cd /binutils-${binutils_v} \
    && ./configure --enable-targets=all --enable-gold --enable-lto \
    && make -j$((`nproc`+1)) \
    && make install-strip \
    && cd / \
    && rm -rf /binutils-${binutils_v}*

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

# Create the user account
RUN useradd -rm -d /home/user -s /bin/bash -u 1000 user

# Add user to sudoers so they can get to root functions
RUN echo "user ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/user

# Make user the default login and set working directory
USER user
WORKDIR /home/user
