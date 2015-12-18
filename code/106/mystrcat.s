.globl mystrcat
mystrcat:
#%r3: dest
#%r4: src
#keep %r3 for returning
	mr %r5, %r3

#loop %r5 to end of dest
count_dest:
	lbz %r6, 0(%r5) #load current to %r6
	cmpwi %cr7, %r6, 0 #compare to 0
	beq %cr7, count_done
	addi %r5, %r5, 1
	b count_dest
count_done:
#now %r5 point to end of dest

#%r4 point to current position on src
copy_loop:
	lbz %r6, 0(%r4) #load current
	cmpwi %cr7,%r6,0
	stb %r6, 0(%r5) #copy to dst
	beq %cr7,copy_done
	addi %r4, %r4, 1
	addi %r5, %r5, 1
	b copy_loop

copy_done:
	stb %r6, 0(%r5) #set terminal character for dst
	blr
