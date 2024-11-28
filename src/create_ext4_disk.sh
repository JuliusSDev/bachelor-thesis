#!/bin/bash
KERNEL_VERSION=6.6.56
KERNEL_MAJOR_VERSION=$(echo $KERNEL_VERSION | cut -d. -f1)
BUSYBOX_VERSION=1.37.0

mkdir -p build

# Create ext4 disk
cd build
    dd if=/dev/zero of=ext4.img bs=4k count=2048
    mkfs.ext4 ext4.img
    tune2fs -c0 -i0 ext4.img
cd ..
