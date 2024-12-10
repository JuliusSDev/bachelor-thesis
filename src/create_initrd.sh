#!/bin/bash
KERNEL_VERSION=6.6.56
KERNEL_MAJOR_VERSION=$(echo $KERNEL_VERSION | cut -d. -f1)
BUSYBOX_VERSION=1.37.0
mkdir -p build

# Create initrd-disk 
cd build    
rm -rf initrd
mkdir -p initrd
    cd initrd
        mkdir -p bin dev proc sys
        cd bin 
            cp ../../../source/busybox-$BUSYBOX_VERSION/busybox .

            for prog in $(./busybox --list); do
                ln -s /bin/busybox ./$prog
            done

        cd ..

        cp ../../init .

        
        chmod -R 777 .
        
        find . | cpio -o -H newc > ../initrd.img
    cd ..
cd ..
