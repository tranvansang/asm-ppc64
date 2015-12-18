#default
dword_length = 8
stack_local_var = 112
stack_param_area = 48
stack_lr = 16
stack_sp = 0

.set r0, 0
.set r1, 1
.set r2, 2
.set r3, 3
.set r4, 4
.set r5, 5
.set r6, 6
.set r7, 7
.set r8, 8
.set r9, 9
.set r10, 10
.set r11, 11
.set r12, 12
.set r13, 13
.set r14, 14
.set r15, 15
.set r16, 16
.set r17, 17
.set r18, 18
.set r19, 19
.set r20, 20
.set r21, 21
.set r22, 22
.set r23, 23
.set r24, 24
.set r25, 25
.set r26, 26
.set r27, 27
.set r28, 28
.set r29, 29
.set r30, 30
.set r31, 31

.set f0, 0
.set f1, 1
.set f2, 2
.set f3, 3
.set f4, 4
.set f5, 5
.set f6, 6
.set f7, 7
.set f8, 8
.set f9, 9
.set f10, 10
.set f11, 11
.set f12, 12
.set f13, 13
.set f14, 14
.set f15, 15
.set f16, 16
.set f17, 17
.set f18, 18
.set f19, 19
.set f20, 20
.set f21, 21
.set f22, 22
.set f23, 23
.set f24, 24
.set f25, 25
.set f26, 26
.set f27, 27
.set f28, 28
.set f29, 29
.set f30, 30
.set f31, 31

.set sp, r1 #%r1
.set toc, r2 #%r2

#program specific
local_var_count = 0

.set param_reg_1, r3
.set param_reg_2, r4
.set param_reg_3, r5
.set param_reg_4, r6
.set param_reg_5, r7
.set param_reg_6, r8
.set param_reg_7, r9
.set param_reg_8, r10

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
	\var = r3 + \param_no - 1
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
