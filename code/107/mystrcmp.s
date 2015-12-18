.global mystrcmp
mystrcmp:
#%r3: sa
#%r4: sb

loop:
	lbz %r5, 0(%r3)
	lbz %r6, 0(%r4)
	cmpwi %cr7, %r5, 0
	beq %cr7, end
	cmpwi %cr7, %r6, 0
	beq %cr7, end
	cmp %cr7, 0, %r5, %r6
	beq %cr7, continuous

end:
	cmp %cr7, 0, %r5, %r6
	blt %cr7, less
	bgt %cr7, greater
	li %r3, 0
	blr
less:
	li %r3, -1
	blr
greater:
	li %r3, 1
	blr

continuous:
	addi %r3, %r3, 1
	addi %r4, %r4, 1
	b loop
