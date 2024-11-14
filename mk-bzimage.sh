#!/bin/bash

# Deps:
# flex
# libelf-dev

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

cd linux
make mrproper
cp ../linux-config .config
make -j$(nproc) bzImage
cd ..
[ -f "bzimage" ] && rm -rf "bzimage"
mv linux/arch/x86/boot/bzImage bzimage