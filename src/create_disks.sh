#!/bin/bash
KERNEL_VERSION=6.6.56
KERNEL_MAJOR_VERSION=$(echo $KERNEL_VERSION | cut -d. -f1)
BUSYBOX_VERSION=1.37.0

rm -rf build

mkdir -p build

# Create ext4 disk
./create_ext4_disk.sh


# Copy kernel to build directory
cp source/linux-$KERNEL_VERSION/arch/x86_64/boot/bzImage build

# Create initrd-disk 
./create_initrd.sh
