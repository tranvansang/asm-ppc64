#!/bin/bash
gcc main.c qsort_asm.s
./a.out
#result
#Configuration:
#	Array size: 524288
#	Max value: 2147483647
#	Run count: 1000
#	Verbose detail: no
#	Stop if sort failed: yes
#	Debug mode: no
#
#
#Total time by system qsort: 237206.153 (ms)
#Total time by asm sort: 40759.009 (ms)
