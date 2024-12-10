# fault_injection.gdb

target remote :1234

break start_kernel

break ext4_get_inode_loc

continue
