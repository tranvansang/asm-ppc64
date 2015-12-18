#default
byte_length = 8
stack_local_var = 112
stack_param_area = 48
stack_lr = 16
stack_sp = 0
.set sp, 1 #%r1

#program specific
local_var_count = 0

.macro param_reg param_no
	(3 + \param_no - 1)
.endm

.macro result_reg result_no
	param_reg \result_no
.endm

.macro param_on_stack instruction param_no postfix=""
	\instruction ((\param_no - 1) * byte_length + stack_param_area)(sp) \postfix
.endm

.macro local_var var_name
	(\var_name)(sp)
.endm

.macro setup_frame
	frame_size = stack_local_var + local_var_count * byte_length
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

.macro declare var
	\var = stack_local_var + byte_length * local_var_count
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
	\var = (\param_no - 1) * byte_length + stack_param_area
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

