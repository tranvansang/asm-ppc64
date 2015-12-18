adr_a = 48
adr_b = 56
adr_len_a = 64
adr_lr = 16
i_greater_result = 1
i_lessthan_result = -1
i_same_result = 0

.global mystrcmp2
mystrcmp2:
	mflr %r0
	std %r0, adr_lr(%r1) #backup lr
	std %r3, adr_a(%r1) #backup a
	std %r4, adr_b(%r1) #backup b
	b start
return: #result has already been set until here
	ld %r0, adr_lr(%r1) #restore lr
	mtlr %r0
	blr
greater_than:
	li %r3, i_greater_result
	b return
less_than:
	li %r3, i_lessthan_result
	b return
same_string:
	li %r3, i_same_result
	b return

start:
#get a's len
	bl c_strlen
	#backup a's len
	stw %r3, adr_len_a(%r1)

#get b len
#set param
	ld %r3, adr_b(%r1)
	bl c_strlen

	mr %r4, %r3
	lwz %r3, adr_len_a(%r1) #get a's len back

	#get a and b back
	ld %r5, adr_a(%r1)
	ld %r6, adr_b(%r1)
loop:
	lbz %r7, 0(%r5) #current char from a
	lbz %r8, 0(%r6) #current char from b
	cmpwi %cr7, %r3, 0
	beq %cr7, end_a #end of a
	cmpwi %cr7, %r4, 0
	beq %cr7, greater_than #end of b but not a
	cmpw %cr7, %r7, %r8
	blt %cr7, less_than
	bgt %cr7, greater_than
	addi %r3, %r3, -1 #remaining chars from a
	addi %r4, %r4, -1 #remaining chars from b
	addi %r5, %r5, 1 #seek a
	addi %r6, %r6, 1 #seek b
	b loop

end_a:
	cmpwi %cr7, %r4, 0
	beq %cr7, same_string #also end of b
	b less_than #end of a but not b
