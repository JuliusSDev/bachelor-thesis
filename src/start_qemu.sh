#!/bin/bash
cd build
qemu-system-x86_64 -kernel bzImage -initrd initrd.img -drive file=ext4.img,format=raw -append "console=ttyS0 nokaslr" -nographic -s -S