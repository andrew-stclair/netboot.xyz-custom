#!/bin/bash

# Deps:
# libelf-dev

cd linux
make mrproper
cp ../linux-config .config
make -j$(nproc) bzImage
cd ..
mv linux/arch/x86/boot/bzImage bzimage