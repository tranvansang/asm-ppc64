.include "lib.s"

.global mul128
mul128:
.set a0, 6
.set a1, 7
.set b0, 8
.set b1, 9
.set c0, 10
.set c1, 3 #be careful from here
.set c2, 4
.set c3, c1
.set tmp, c0

c0_pos = 3 * dword_length
c1_pos = 2 * dword_length
c2_pos = dword_length
c3_pos = 0
a0_pos = dword_length
a1_pos = 0
b0_pos = dword_length
b1_pos = 0

	ld a1, a1_pos(param_reg_1)
	ld a0, a0_pos(param_reg_1)
	ld b1, b1_pos(param_reg_2)
	ld b0, b0_pos(param_reg_2)

	#c0
	mulld c0, a0, b0
	std c0, c0_pos(param_reg_3)

	#c1
	mulhdu tmp, a0, b0
	mulld c1, a1, b0
	addc c1, c1, tmp
	li c2, 0
	addze c2, c2
	mulld tmp, a0, b1
	addc c1, c1, tmp
	addze c2, c2
	std c1, c1_pos(param_reg_3)

	#c2
	mulhdu tmp, a0, b1
	addc c2, c2, tmp
	li c3, 0
	addze c3, c3
	mulhdu tmp, a1, b0
	addc c2, c2, tmp
	addze c3, c3
	mulld tmp, a1, b1
#addze is auto carry
	addc c2, c2, tmp
	std c2, c2_pos(param_reg_3)

#c3
	mulhdu c3, a1, b1 #no carry, no overflow (special case, mode-dependent)
#see 3.3.8 Fixed-Point Arithmetic Instructions, p. 62, Power ISA User Instruction Set Architecture version 2.05
	addze c3, c3
	std c3, c3_pos(param_reg_3)

	#return
	blr
