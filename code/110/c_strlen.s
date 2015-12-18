.globl c_strlen
c_strlen:
	mr 4,3 #assign string pointer to 4
	li 3,0 #init result to 0
loop:
	lbz 5,0(4) #load current char to r5
	cmpwi 7,5,0 #compare with 0
	beq 7,return #break if equal
	addi 3,3,1 #add 1 to result (r3)
	addi 4,4,1 #add 1 to current pointer
	b loop
return:
	blr
