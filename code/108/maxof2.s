.globl maxof2
maxof2:
	cmpw %cr7,%r4,%r3
	ble %cr7,return
	mr %r3,%r4
return:
	extsw %r3,%r3
	blr
