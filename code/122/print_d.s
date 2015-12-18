.include "macro.s"

const_base = 10
const_digit_max = 9 #not include sign
ten_register = 5
zero_char = '0'

.global print_d
print_d:
	cmpdi %cr7, param_reg_1, 0
	beq- %cr7, is_zero
	blt- %cr7, is_negative
#is positive
	li param_reg_2, 0
	li param_reg_3, 1

	li %r6, const_digit_max
	mtctr %r6
	li %r6, const_base
get_big_base:
	mullw param_reg_3, param_reg_3, %r6
	bdnz+ get_big_base

	call sub_print
	blr

is_zero:
	li %r3, 0 + zero_char
	call print_c
	blr

is_negative:
	backup_lr
	backup_param 1

	setup_frame

	li param_reg_1, '-'
	bl print_c

	restore_param_while_calling 1
	neg param_reg_1, param_reg_1
	bl print_d

	restore_frame
	restore_lr
	blr


#param1: positive number to be printed
#param2: 0 if nothing is printed yet
#param3: big base
sub_print:
n = param_reg_1
smt_printed = param_reg_2
big_base = param_reg_3
	cmpdi %cr7, big_base, 0
	beq- %cr7, return
	divdu. %r6, n, big_base
	bne+ %cr0, show_digit

#check if smt is printed before
	cmpi %cr7, smt_printed, 0
	beq+ %cr7, dont_show_digit

show_digit:
	li smt_printed, 1 #cuz smt got printed
	backup_param 1, 4 #also backup %r6
	addi %r6, %r6, zero_char
	mr param_reg_1, %r6
	call print_c
	restore_param 1, 4
	mullw %r6, big_base, %r6
	sub n, n, %r6
dont_show_digit:
	
	li %r6, const_base
	divdu big_base, big_base, %r6
	call sub_print
	blr

return:
	blr
