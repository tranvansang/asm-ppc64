#default
dword_length = 8
stack_local_var = 112
stack_param_area = 48
stack_lr = 16
stack_sp = 0
.set sp, 1 #%r1
.set toc, 2 #%r2

#program specific
local_var_count = 0

.set param_reg_1, 3
.set param_reg_2, 4
.set param_reg_3, 5
.set param_reg_4, 6
.set param_reg_5, 7
.set param_reg_6, 8
.set param_reg_7, 9
.set param_reg_8, 10

.set result_reg_1, param_reg_1
.set result_reg_2, param_reg_2
.set result_reg_3, param_reg_3
.set result_reg_4, param_reg_4
.set result_reg_5, param_reg_5
.set result_reg_6, param_reg_6
.set result_reg_7, param_reg_7
.set result_reg_8, param_reg_8

.set param_on_stack_1, (0 * dword_length + stack_param_area)
.set param_on_stack_2, (1 * dword_length + stack_param_area)
.set param_on_stack_3, (2 * dword_length + stack_param_area)
.set param_on_stack_4, (3 * dword_length + stack_param_area)
.set param_on_stack_5, (4 * dword_length + stack_param_area)
.set param_on_stack_6, (5 * dword_length + stack_param_area)
.set param_on_stack_7, (6 * dword_length + stack_param_area)
.set param_on_stack_8, (7 * dword_length + stack_param_area)

.macro setup_frame
	frame_size = stack_local_var + local_var_count * dword_length
	stdu sp, -frame_size(sp)
.endm


.macro restore_frame
	ld sp, stack_sp(sp)
.endm

.macro inc reg_name
	addi \reg_name, \reg_name, 1
.endm

.macro dec reg_name
	addi \reg_name, \reg_name, -1
.endm

#declare var as an offset from stack pointer AFTER frame for subroutine is set up
#there is less need of local variable in case of leaf function
.macro declare var
	\var = stack_local_var + dword_length * local_var_count
	local_var_count = local_var_count + 1
.endm

.macro backup_lr
	mflr %r0
	std %r0, stack_lr(sp)
.endm

.macro restore_lr
	ld %r0, stack_lr(sp)
	mtlr %r0
.endm

.macro assign_param_reg var param_no
	\var = 3 + \param_no - 1
.endm

.macro assign_param_on_stack var param_no
	\var = (\param_no - 1) * dword_length + stack_param_area
.endm

.macro call_init from=1 to=-1
	assign_param_reg reg, \from
	assign_param_on_stack st, \from
	std reg, st(sp)
	#std "(param_reg \from)", "(param_on_stack \from)"
	.if \to + 1
		.if \from-\to
			call_init "(\from + 1)", \to
		.endif
	.endif
.endm

#not tested
.macro local_var var_name
	(\var_name)(sp)
.endm
