#!/bin/bash

[ -f "bzimage" ] || sudo ./mk-bzimage.sh
[ -f "initrd.gz" ] || sudo ./mk-initrd.sh

qemu-system-x86_64 -kernel bzimage -initrd initrd.gz -append "console=ttyS0 rootwait rw" -nographic -m 8G
