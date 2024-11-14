#!/bin/bash

# Deps:
# cpio

WORKDIR=$(pwd)
BUSYBOX_INITRD_DIR="${WORKDIR}/busybox-initrd"
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
chmod +s ${BUSYBOX_INITRD_DIR}/bin/busybox

# Create the init file
echo << EOF > ${BUSYBOX_INITRD_DIR}/init
#!/bin/sh

mount -t devtmpfs devtmpfs /dev
mount -t proc none /proc
mount -t sysfs none /sys

cat <<!

Welcome to BusyBox Linux!
Boot took $(cut -d' ' -f1 /proc/uptime) seconds

!
exec /bin/sh
EOF

chmod +x ${BUSYBOX_INITRD_DIR}/init

cd ${BUSYBOX_INITRD_DIR}
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ${WORKDIR}/initrd.gz
cd ${WORKDIR}
rm -rf ${BUSYBOX_INITRD_DIR}
