.include "lib.s"
.global matmul_s

#x , y, z
#load z-th element from array y to register x
#note: value of z is changed
.macro load_from_array x y z
	add \z, \z, \y
	lfd \x, 0(\z)
.endm

#mat_pos x, y, z
#take y-th row, z-th column position of nxn size matrix
#result: x
.macro mat_pos x y z
	muli \x, \y, n
	add \x, \x, \z
	muli \x, \x, dword_length
.endm

#store value in register x to z-th element of array y
#note: value of z is changed
.macro store_to_array x y z
	add \z, \z, \y
	stfd \x, 0(\z)
.endm

zero:
	.quad .TOC.@tocbase, 0

a_array = param_reg_1
b_array = param_reg_2
c_array = param_reg_3
i = r6
j = r7
k = r8
pos = r9
n = 4
sum = f1
a = f2
b = f3
zeror = f4

matmul_s:
li i, 0
std i, -dword_length(sp)
lfd zeror, -dword_length(sp)
loop_i:
	li j, 0
	loop_j:
		li k, 0
		fmr sum, zeror
		loop_k:
			#load a
			mat_pos pos, i, k
			load_from_array a, a_array, pos

			#load b
			mat_pos pos, k, j
			load_from_array b, b_array, pos

			#add to sum
			fmadd sum, a, b, sum

			inc k
			cmpwi %cr7, k, n
			bne+ %cr7, loop_k

		#save result
		mat_pos pos i, j
		store_to_array sum, c_array, pos

		inc j
		cmpwi %cr7, j, n
		bne+ %cr7, loop_j

	inc i
	cmpwi %cr7, i, n
	bne+ %cr7, loop_i

	blr
