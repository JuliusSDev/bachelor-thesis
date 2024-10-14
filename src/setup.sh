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
        make defconfig 
        echo 'CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y' >> .config
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



cd ..

mkdir -p build

# Create ext4 disk
cd build
    dd if=/dev/zero of=ext4.img bs=4k count=2048
    mkfs.ext4 ext4.img
    tune2fs -c0 -i0 ext4.img
cd ..


# Copy kernel to build directory
cp source/linux-$KERNEL_VERSION/arch/x86_64/boot/bzImage build

# initrd 
cd build    
mkdir -p initrd
    cd initrd
        mkdir -p bin dev proc sys
        cd bin 
            cp ../../../source/busybox-$BUSYBOX_VERSION/busybox .

            for prog in $(./busybox --list); do
                ln -s /bin/busybox ./$prog
            done

        cd ..

        echo '#!/bin/sh' > init
        echo 'mount -t sysfs sysfs /sys' >> init
        echo 'mount -t proc proc /proc' >> init
        echo 'mount -t devtmpfs udev /dev' >> init
        echo 'sysctl -w kernel.printk="2 4 1 7"' >> init
        echo 'mkdir -p /mnt/ext4_disk' >> init
        echo 'mount -t ext4 /dev/sda /mnt/ext4_disk' >> init
        echo '/bin/sh' >> init

        
        chmod -R 777 .
        
        find . | cpio -o -H newc > ../initrd.img
    cd ..
cd ..