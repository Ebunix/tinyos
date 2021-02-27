#!/bin/bash

set GCC_VERSION = 10.2.0
set BINUTILS_VERSION = 2.36.1

echo "[Info] Updating apt package cache"
apt-get update -qq > /dev/null
echo "[Info] Upgrading apt packages, this might take a while"
apt-get upgrade -y -qq > /dev/null
echo "[Info] Installing build requirements"
apt-get install -y nasm xorriso grub-pc-bin grub-common -qq > /dev/null
echo "[Info] Installing gcc/binutils requirements"
apt-get install -y build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo -qq > /dev/null

echo "[Info] Downloading gcc ($GCC_VERSION) and binutils ($BINUTILS_VERSION)"
mkdir -p env
cd env
wget https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz
wget https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.xz
cd ..
