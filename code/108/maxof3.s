.globl maxof3
maxof3:
	mflr %r0
	std %r0, -16(%r1) #save lr
	std %r5, -32(%r1) #save 3rd param
	addi %r1, %r1, -32 #update sp
	bl maxof2
	ld %r4, 0(%r1) #restore 3rd param
	bl maxof2
	ld %r0, 16(%r1) #restore lr
	mtlr %r0
	addi %r1, %r1, 32 #restore sp
	blr
