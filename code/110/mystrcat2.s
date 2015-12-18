.include "lib.s"

#local_var
declare stack_a_len
#declare a
#declare b

a = frame_size + stack_param_area + 0 * byte_length
b = frame_size + stack_param_area + 1 * byte_length

.global mystrcat2
mystrcat2:

#backup lr
backup_lr
#setup frame
setup_frame

#backup a and b
	std %r3, a(sp)
	std %r4, b(sp)

#get a's len
	call_init 1
	bl c_strlen
	std %r3, stack_a_len(sp)


#get b's len
	ld %r3, b(sp)
	call_init 1
	bl c_strlen

	.set b_len, 3 #%r3
	.set a_len, 7 #%r7
	.set pos_a, 4 #%r4
	.set pos_b, 5 #%r5
	.set char_b, 6 #%r6
#seek to end of a
	ld a_len, stack_a_len(sp)
	cmpwi %cr7, a_len, 0
	ld pos_a, a(sp)
	beq- %cr7, no_seek_a
	mtctr a_len
seek_a:
	inc pos_a
	bdnz+ seek_a
	no_seek_a:

	ld pos_b, b(sp)
	inc b_len
	mtctr b_len
#append b to a
	append:
	lbz char_b, 0(pos_b)
	stb char_b, 0(pos_a)
	inc pos_a
	inc pos_b
	bdnz+ append

#restore sp, lr
	ld %r3, a(sp)
	restore_frame
	restore_lr
	blr
