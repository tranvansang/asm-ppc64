	.file	"c1-1.c"
	.section	".toc","aw"
	.section	".text"
	.section	.rodata
	.align 3
.LC0:
	.string	"%d + %d = %d\n"
	.section	".toc","aw"
.LC1:
	.quad	.LC0
	.section	".text"
	.align 2
	.globl main
	.section	".opd","aw"
	.align 3
main:
	.quad	.L.main,.TOC.@tocbase,0
	.previous
	.type	main, @function
.L.main:
	mflr %r0
	std %r0,16(%r1)
	std %r31,-8(%r1)
	stdu %r1,-144(%r1)
	mr %r31,%r1
	li %r9,1
	stw %r9,112(%r31)
	li %r9,2
	stw %r9,116(%r31)
	li %r9,0
	stw %r9,120(%r31)
	lwz %r10,112(%r31)
	lwz %r9,116(%r31)
	add %r9,%r10,%r9
	stw %r9,120(%r31)
	lwz %r9,112(%r31)
	extsw %r8,%r9
	lwz %r9,116(%r31)
	extsw %r10,%r9
	lwz %r9,120(%r31)
	extsw %r9,%r9
	ld %r3,.LC1@toc(%r2)
	mr %r4,%r8
	mr %r5,%r10
	mr %r6,%r9
	bl printf
	nop
	mr %r3,%r9
	addi %r1,%r31,144
	ld %r0,16(%r1)
	mtlr %r0
	ld %r31,-8(%r1)
	blr
	.long 0
	.byte 0,0,0,1,128,1,0,1
	.size	main,.-.L.main
	.ident	"GCC: (GNU) 4.8.2"
