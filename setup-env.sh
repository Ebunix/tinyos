#!/bin/bash

set GCC_VERSION = 10.2.0
set BINUTILS_VERSION = 2.36.1

echo [Info] Updating apt package cache
apt-get update -qq > /dev/null
echo [Info] Upgrading apt packages, this might take a while
apt-get upgrade -y -qq > /dev/null
echo [Info] Installing build requirements
apt-get install -y nasm -qq > /dev/null
apt-get install -y xorriso -qq > /dev/null
apt-get install -y grub-pc-bin -qq > /dev/null
apt-get install -y grub-common -qq > /dev/null
apt-get install -y build-essential -qq > /dev/null
echo [Info] Installing gcc/binutils requirements
apt-get install -y bison -qq > /dev/null
apt-get install -y flex -qq > /dev/null
apt-get install -y libgmp3-dev -qq > /dev/null
apt-get install -y libmpc-dev -qq > /dev/null
apt-get install -y libmpfr-dev -qq > /dev/null
apt-get install -y texinfo -qq > /dev/null

echo [Info] Downloading gcc ($GCC_VERSION) and binutils ($BINUTILS_VERSION)
mkdir -p env
cd env
wget https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz
wget https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.xz
cd ..
