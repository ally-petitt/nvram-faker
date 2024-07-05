#!/bin/bash

set -e # exit on failure

if [ $# -ne 4 ]; then
  echo "Usage: $0 <compilation_toolchain_binaries_path> <squashfs_root_path> <newlib_path> <target_binary_path>"
  echo "Example: $0 $HOME/x-tools/armeb-unknown-eabi/bin $HOME/_extracted_firmware/squashfs-root $HOME/Documents/firmware/crosstool-ng/.build/src/newlib-4.3.0.20230120/newlib/libc/include /usr/sbin/httpd"
  exit 1
fi

TOOLCHAIN_PATH=$1
SQUASHFS_PATH=$2
NEWLIB_PATH=$3
TARGET_BINARY=$4

make clean
make CC="${TOOLCHAIN_PATH}/armeb-unknown-eabi-gcc" CFLAGS="-DDEBUG=1 -I${NEWLIB_PATH}" LD="${TOOLCHAIN_PATH}/armeb-unknown-eabi-ld AR=${TOOLCHAIN_PATH}/armeb-unknown-eabi-ar STRIP=${TOOLCHAIN_PATH}/armeb-unknown-eabi-strip NM=${TOOLCHAIN_PATH}/armeb-unknown-eabi-nm"

cp ./libnvram-faker.so "${SQUASHFS_PATH}"
sudo chroot "${SQUASHFS_PATH}" ./qemu-armeb-static -E LD_PRELOAD=/libnvram-faker.so "${TARGET_BINARY}"
