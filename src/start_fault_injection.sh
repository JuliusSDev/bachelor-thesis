#!/bin/bash
KERNEL_VERSION=6.6.56
KERNEL_MAJOR_VERSION=$(echo $KERNEL_VERSION | cut -d. -f1)
BUSYBOX_VERSION=1.37.0

gdb -x fault_injection.gdb source/linux-$KERNEL_VERSION/vmlinux
