#!/bin/bash
gcc main.c mul128.s
./a.out

#result
#   [0xffffffffffffffff, 0xffffffffffffffff]
# + [0xffffffffffffffff, 0xffffffffffffffff]
# = [0xfffffffffffffffe, 0xfffffffffffffffe, 000000000000000000, 0x0000000000000001]
