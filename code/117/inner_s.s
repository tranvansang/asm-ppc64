.include "lib.s"
.global inner_s
.set n, 4 #n must be POSITIVE ( > 0)
.set result, 1
zero:
	.quad .TOC.@tocbase, 0
inner_s:
	li %r5, n
	mtctr %r5
	lfd result, zero@got(toc)

.set a_array, param_reg_1
.set b_array, param_reg_2
.set a, 2
.set b, 3
loop:
	lfd a, 0(a_array)
	lfd b, 0(b_array)
	fmadd result, a, b, result
	addi a_array, a_array, dword_length
	addi b_array, b_array, dword_length
	bdnz+ loop

	blr
