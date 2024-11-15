#!/bin/bash

[ -f "bzimage" ] || sudo ./mk-bzimage.sh
[ -f "initrd" ] || sudo ./mk-initrd.sh

qemu-system-x86_64 -kernel bzimage -initrd initrd -append "console=ttyS0 rootwait rw" -nographic -m 8G
