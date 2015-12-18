.include "lib.s"
.global add128
add128:
.set a0, 6
.set a1, 7
.set b0, 8
.set b1, 9
.set c0, 10
.set c1, 3 #be careful here. Dont use param_reg_1 after c1 is used
#load value
	ld a0, 8(param_reg_1)
	ld a1, 0(param_reg_1)
	ld b0, 8(param_reg_2)
	ld b1, 0(param_reg_2)

#do add
	addc. c0, a0, b0
	adde c1, a1, b1

#save result
	std c0, 8(param_reg_3)
	std c1, 0(param_reg_3)

	blr
