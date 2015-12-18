.include "lib.s"
.global fact
.set n, 4

#n must be positive
fact:
	cmpdi %cr7, param_reg_1, 1
	beqlr %cr7
	stw param_reg_1, param_on_stack_1(sp)

	backup_lr
	setup_frame

	dec param_reg_1
	call_init 1
	bl fact

	restore_frame
	restore_lr

	lwz n, param_on_stack_1(sp)
	mullw result_reg_1, result_reg_1, n
	blr
