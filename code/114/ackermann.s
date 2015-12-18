.include "lib.s"

.global ackermann
ackermann:

	cmpdi %cr7, param_reg_1, 0
	beq %cr7, m_is_0


	cmpdi %cr7, param_reg_2, 0
	beq %cr7, n_is_0
	#return A(m - 1, A(m, n - 1))

#backup m, n
	stw param_reg_1, param_on_stack_1(sp)
	stw param_reg_1, param_on_stack_2(sp)

	backup_lr
	setup_frame

	dec param_reg_2
	bl ackermann

	mr param_reg_2, result_reg_1
	lwz param_reg_1, (frame_size + param_on_stack_1)(sp)
	dec param_reg_1
	bl ackermann

	restore_frame
	restore_lr

	blr

n_is_0:#return A(M- 1, 1)
	dec param_reg_1
	li param_reg_2, 1

	backup_lr
	setup_frame

	bl ackermann

	restore_frame
	restore_lr

	blr

m_is_0: #return n + 1
	addi result_reg_1, param_reg_2, 1
	blr
