.include "macro.s"
.global print_c
#param1: char to be printed
print_c:
	li      0,4         # syscall number (sys_write)
	stb param_reg_1, param_on_stack_1(sp)
	li      param_reg_1,1         # first argument: file descriptor (stdout)
	addi param_reg_2, sp, param_on_stack_1 # second argument: pointer to message to write
	li param_reg_3, 1 #msg length
	sc
	blr
