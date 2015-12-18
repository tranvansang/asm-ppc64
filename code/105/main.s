	.file	"main.c"
	.section	".toc","aw"
	.section	".text"
	.section	".toc","aw"
.LC1:
	.quad	.LC0
.LC3:
	.quad	.LC2
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
	stdu %r1,-112(%r1)
	ld %r3,.LC1@toc(%r2)
	bl c_strlen
	nop
	mr %r4,%r3
	ld %r3,.LC3@toc(%r2)
	bl printf
	nop
	li %r3,0
	addi %r1,%r1,112
	ld %r0,16(%r1)
	mtlr %r0
	blr
	.long 0
	.byte 0,0,0,1,128,0,0,0
	.size	main,.-.L.main
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 3
.LC0:
	.string	"hello, world!"
	.zero	2
.LC2:
	.string	"strlen's result: %d\n"
	.ident	"GCC: (GNU) 4.8.2"
