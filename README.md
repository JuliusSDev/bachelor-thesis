# bachelor-thesis
# Shell scripts

## setup
Used, to setup the whole environment, only has to be executed once. This script can take several minutes to finish.

 **Linux-Kernel:**
 - Installs necessary libraries to build the Linux-Kernel
 - Downloads the Linux-Kernel
 - Replace the config with an own config
 - Builds the Linux-Kernel

**Busybox:**
 - Downloads Busybox
 - Builds Busybox

This script also executes create_disks.sh

## create_disks
This script will be called in setup.sh and should setup the disks, needed in for the VM.
 - Removes old build directory
 - Creates a new build directory
 - Executes create_ext4_disk.sh
 - Copies bzImage into build
 - Executes create_initrd.sh

## create_ext4_disk
This script creates an empty ex4-disk, to be used in the qemu-vm.

## create_initrd
This script creates a default root directory with busybox and with a init-script, which contains a small benchmark with read/write operations on the ext4-disk.

## start_qemu
Starts qemu with the ext4-disk and gdb

## start_fault_injection
This script starts gdb with the Kernel-Debugging signals and executes an automatic gdb-script

