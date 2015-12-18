.include "macro.s"
.global print_s
stdout = 1
sys_write = 4
print_s:
	backup_param 1
	call strlen
	mr param_reg_3, result_reg_1 #msg length

	li      r0,sys_write         # syscall number (sys_write)
	ld param_reg_2, param_on_stack_1(sp) # second argument: pointer to message to write
	li      param_reg_1,stdout         # first argument: file descriptor (stdout)
	sc

	blr
