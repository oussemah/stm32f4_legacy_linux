#!/bin/sh
# Written by Uwe Hermann <uwe@hermann-uwe.de>, released as public domain.

TARGET=arm-elf			 # Or: TARGET=arm-none-eabi
PREFIX=/tmp/arm-cortex-toolchain # Install location of your final toolchain
PARALLEL="-j 2"			 # Or: PARALLEL=""

BINUTILS=binutils-2.19.1
GCC=gcc-4.3.3
NEWLIB=newlib-1.17.0
GDB=gdb-6.8

export PATH="$PATH:$PREFIX/bin"

mkdir build

wget -c http://ftp.gnu.org/gnu/binutils/$BINUTILS.tar.bz2
tar xfvj $BINUTILS.tar.bz2 
cd build
../$BINUTILS/configure --target=$TARGET --prefix=$PREFIX --enable-interwork --enable-multilib --with-gnu-as --with-gnu-ld --disable-nls
make $PARALLEL
make install
cd ..
rm -rf build/* $BINUTILS $BINUTILS.tar.bz2

wget -c ftp://ftp.gnu.org/gnu/gcc/$GCC/$GCC.tar.bz2
tar xfvj $GCC.tar.bz2 
cd build
../$GCC/configure --target=$TARGET --prefix=$PREFIX --enable-interwork --enable-multilib --enable-languages="c" --with-newlib --without-headers --disable-shared --with-gnu-as --with-gnu-ld
make $PARALLEL all-gcc
make install-gcc
cd ..
rm -rf build/* $GCC.tar.bz2

wget -c ftp://sources.redhat.com/pub/newlib/$NEWLIB.tar.gz
tar xfvz $NEWLIB.tar.gz
cd build
../$NEWLIB/configure --target=$TARGET --prefix=$PREFIX --enable-interwork --enable-multilib --with-gnu-as --with-gnu-ld --disable-nls
make $PARALLEL
make install
cd ..
rm -rf build/* $NEWLIB $NEWLIB.tar.gz

# Yes, you need to build gcc again!
cd build
../$GCC/configure --target=$TARGET --prefix=$PREFIX --enable-interwork --enable-multilib --enable-languages="c,c++" --with-newlib --disable-shared --with-gnu-as --with-gnu-ld
make $PARALLEL
make install
cd ..
rm -rf build/* $GCC

wget -c ftp://ftp.gnu.org/gnu/gdb/$GDB.tar.bz2
tar xfvj $GDB.tar.bz2
cd build
../$GDB/configure --target=$TARGET --prefix=$PREFIX --enable-interwork --enable-multilib
make $PARALLEL
make install
cd ..
rm -rf build $GDB $GDB.tar.bz2


