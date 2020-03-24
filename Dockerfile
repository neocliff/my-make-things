FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates binutils git make g++ g++-multilib g++-7-multilib \
    gcc-7-doc apt-utils libstdc++6-7-dbg libstdc++-7-doc libacl1-dev \
    flex bison texinfo wget xz-utils doxygen libtool build-essential \
&& rm -rf /var/lib/apt/lists/*

ARG m4_v=1.4.18
ARG sed_v=4.8
ARG gawk_v=5.0.1
ARG binutils_v=2.33.1
ARG make_v=4.3
ARG gcc_v=9.2.0
ARG zstd_v=1.4.4

# Download, configure, install necessary source code packages
RUN wget https://ftp.gnu.org/gnu/m4/m4-${m4_v}.tar.xz \
    && tar -Jxf m4-${m4_v}.tar.xz \
    && cd /m4-${m4_v} \
    && ./configure \
    && make -j$((`nproc`+1)) \
    && make install-strip \
    && cd / \
    && rm -rf /m4-${m4_v}

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
    && ../configure --with-cpu-32=i686 --with-cpu-64=core2 --with-multiarch --with-gnu-ld \
        --with-gnu-as --with-multilib-list=m32,mx32,m64 --enable-threads \
    && make -j$((`nproc`+1)) \
    && make install-strip \
    && cd / \
    && rm -rf /gcc-${gcc_v}*

RUN useradd -rm -d /home/user -s /bin/bash -u 1000 user
USER user
WORKDIR /home/user
