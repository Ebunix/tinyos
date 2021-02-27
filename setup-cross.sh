#!/bin/bash

GCC_VERSION=10.2.0
BINUTILS_VERSION=2.36.1

mkdir -p env
cd env

if [ ! -d "gcc-$GCC_VERSION" ]; then
    if [ ! -f "gcc-$GCC_VERSION.tar.xz" ]; then
        echo "[Info] Downloading gcc ($GCC_VERSION)"
        wget -q "https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz"
    fi
    echo "[Info] Unpacking gcc"
    tar -xf "gcc-$GCC_VERSION.tar.xz"
fi

if [ ! -d "binutils-$BINUTILS_VERSION" ]; then
    if [ ! -f "binutils-$BINUTILS_VERSION.tar.xz" ]; then
        echo "[Info] Downloading binutils ($BINUTILS_VERSION)"
        wget -q "https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.xz" 
    fi
    echo "[Info] Unpacking binutils"
    tar -xf "binutils-$BINUTILS_VERSION.tar.xz"
fi

export PREFIX="$HOME/opt/cross"
export TARGET=x86_64-elf
export PATH="$PATH:$PREFIX/bin"

if [ ! -d "binutils-build" ]; then
    mkdir -p binutils-build
    cd binutils-build
    ../binutils-$BINUTILS_VERSION/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
    make -j4
    make install
    cd ..
fi
if [ ! -d "gcc-build" ]; then
    mkdir -p gcc-build
    cd gcc-build
    ../gcc-$GCC_VERSION/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
    make all-gcc -j4 
    make all-target-libgcc -j4
    make install-gcc
    make install-target-libgcc 
    cd ..
fi

cd ..
echo "[Info] All done! You may delete the 'env' directory now"
