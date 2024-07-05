#!/bin/sh

export ARCH=arm
TARGET=$1
export CFLAGS=-mbig-endian

# Sets up toolchain environment variables for arm toolchain
# Tested against armv7-eabihf, glibc from toolchains.free-electrons.com

warn()
{
	echo "$1" >&2
}

if [ ! -z $(which arm-none-eabi-gcc) ];
then
	export CC=$(which arm-none-eabi-gcc)
else
	warn "Not setting CC: can't locate arm-none-eabi-gcc."
fi

if [ ! -z $(which arm-none-eabi-ld) ];
then
	export LD=$(which arm-none-eabi-ld)
else
	warn "Not setting LD: can't locate arm-none-eabi-ld."
fi

if [ ! -z $(which arm-none-eabi-ar) ];
then
	export AR=$(which arm-none-eabi-ar)
else
	warn "Not setting AR: can't locate arm-none-eabi-ar."
fi


if [ ! -z $(which arm-none-eabi-strip) ];
then
	export STRIP=$(which arm-none-eabi-strip)
else
	warn "Not setting STRIP: can't locate arm-none-eabi-strip."
fi

if [ ! -z $(which arm-none-eabi-nm) ];
then
	export NM=$(which arm-none-eabi-nm)
else
	warn "Not setting NM: can't lcoate arm-none-eabi-nm."
fi


make $TARGET || exit $?
