#!/bin/bash
KERNEL_VERSION=6.6.56
KERNEL_MAJOR_VERSION=$(echo $KERNEL_VERSION | cut -d. -f1)
BUSYBOX_VERSION=1.37.0

# install dependencies
sudo apt-get install libncurses-dev flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf -y
rm -rf source build
mkdir -p source
cd source


    # Kernel
    wget https://cdn.kernel.org/pub/linux/kernel/v$KERNEL_MAJOR_VERSION.x/linux-$KERNEL_VERSION.tar.xz
    tar -xf linux-$KERNEL_VERSION.tar.xz
    cd linux-$KERNEL_VERSION
        cp ../../.config .
        make oldconfig
        make -j$(nproc) || exit
    cd ..


    # Busybox
    wget https://busybox.net/downloads/busybox-$BUSYBOX_VERSION.tar.bz2
    tar -xf busybox-$BUSYBOX_VERSION.tar.bz2
    cd busybox-$BUSYBOX_VERSION
        make defconfig
        sed 's/^.*CONFIG_STATIC[^_].*$/CONFIG_STATIC=y/g' -i .config
        make -j$(nproc) || exit
    cd ..

./create_disks.sh