.include "macro.s"
.global strlen
char = r4
string = r5
strlen:
	mr string, param_reg_1
	li result_reg_1, 0
loop:
	lbz char, 0(string)
	inc result_reg_1
	inc string
	cmpi %cr7, char, 0
	bne+ %cr7, loop

	dec result_reg_1
	blr
