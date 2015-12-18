.include "lib.s"

.global fibo
.set last_ret_reg, 4
fibo:
	cmpdi %cr7, param_reg_1, 2
	bltlr %cr7
#backup n
	stw param_reg_1, param_on_stack_1(sp)
	declare last_ret

	backup_lr
	setup_frame

	dec param_reg_1
	#call_init 1
	bl fibo
	stw result_reg_1, last_ret(sp)

	lwz param_reg_1, (param_on_stack_1 + frame_size)(sp)
	addi param_reg_1, param_reg_1, -2
	#call_init 1
	bl fibo

	lwz last_ret_reg, last_ret(sp)

	restore_frame
	restore_lr

	add result_reg_1, result_reg_1, last_ret_reg
	blr
