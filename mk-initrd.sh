#!/bin/bash

# Deps:
# cpio

# Make sure we are root
# the setuid bit runs the program as the user who owns the program
# therefore we want everything in the filesystem to be owned by root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

WORKDIR=$(pwd)
BUSYBOX_INITRD_DIR="${WORKDIR}/busybox.initrd"
BUSYBOX_REPO="${WORKDIR}/busybox"

# Mount it so that we can populate
mkdir -p ${BUSYBOX_INITRD_DIR}
mkdir -p ${BUSYBOX_INITRD_DIR}/bin ${BUSYBOX_INITRD_DIR}/sbin ${BUSYBOX_INITRD_DIR}/etc ${BUSYBOX_INITRD_DIR}/proc ${BUSYBOX_INITRD_DIR}/sys ${BUSYBOX_INITRD_DIR}/dev ${BUSYBOX_INITRD_DIR}/usr/bin ${BUSYBOX_INITRD_DIR}/usr/sbin

# Install busybox
cd ${BUSYBOX_REPO}
make mrproper
cp ${WORKDIR}/busybox-config .config
make -j$(nproc)
make CONFIG_PREFIX=${BUSYBOX_INITRD_DIR} install
cd ${WORKDIR}
chmod +sx ${BUSYBOX_INITRD_DIR}/bin/busybox

# Add includes
cp -r ${WORKDIR}/busybox.includes/* ${BUSYBOX_INITRD_DIR}/.

cd ${BUSYBOX_INITRD_DIR}
[ -f "${WORKDIR}/initrd.gz" ] && rm -rf "${WORKDIR}/initrd.gz"
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ${WORKDIR}/initrd.gz
cd ${WORKDIR}
rm -rf ${BUSYBOX_INITRD_DIR}
