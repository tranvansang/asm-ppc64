.include "lib.s"
.global qsort_asm

#take low and high addresses
low = param_reg_1
high = param_reg_2
pivot = r5
i = r6
j = r7
vi = r8
vj = r9
size_of_int = 4

qsort_asm:
	cmpw %cr7, low, high
	bnllr- %cr7

	lwz pivot, 0(low)
	mr i, low
	mr j, high

	partition:
		#while a[i] < pivot
		loop_i:
			lwz vi, 0(i)
			inc i, size_of_int
			cmpw %cr7, vi, pivot
			blt+ %cr7, loop_i
		dec i, size_of_int

		#while a[j] > pivot
		loop_j:
			lwz vj, 0(j)
			dec j, size_of_int
			cmpw %cr7, vj, pivot
			bgt+ %cr7, loop_j
		inc j, size_of_int

		#swap
		cmpw %cr7, i, j
		bgt- %cr7, dont_swap
			stw vi, 0(j)
			stw vj, 0(i)
			inc i, size_of_int
			dec j, size_of_int
		dont_swap:

		cmpw %cr7, i, j
		bng+ %cr7, partition

#backup i, h
	backup_param 2
	std i, param_on_stack_1(sp)
#prepare for first call
	mr param_reg_2, j
	backup_lr
	setup_frame
	bl qsort_asm #sort l, j

	restore_param_while_calling 1, 2
	bl qsort_asm #sort i, h
	
	restore_frame
	restore_lr
	blr
