#!/bin/bash
KERNEL_VERSION=6.6.56
KERNEL_MAJOR_VERSION=$(echo $KERNEL_VERSION | cut -d. -f1)
BUSYBOX_VERSION=1.37.0

mkdir -p build

# Create initrd-disk 
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
