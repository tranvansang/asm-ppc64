#Self-paced note

From [this book](http://physinfo.ulb.ac.be/divers_html/powerpc_programming_info/intro_to_ppc/ppc0_index.html)

# General

1. RISC

	Prefer register operations

	Integrated caches

	Pipeline model: multiple instructions per clock cycle(??)

2. PowerPC

	Branch Processor uses fixed-point and floating-point units

	`Stall` or `bubble` means: while RISC design keeps CPU being busy, some `if`, `call` or `goto` commands need loading data from RAM but that secsion is has not been prefetched.
	
	PowerPC has a seperate unit to detecting upcoming branches and managing the instruction queue. It looks for last few instructions and prefetches branches, help decrase `bubbles`

	Fixed-piont processor, floating-point processor and branch process are seperated and indepedent units. They can simultaneously execute 1 instruction.

	RISC restricts memory access by align.

	Bits numbering: in all PowerPC documentation, most left-hand bit is numbered 0, and rised to the right


#Details

0. Abbreviation

- GPR: general purpose register.

- FPR: floating-point register.

- CR: condition register.

- CTR: count register.

- LR: link register.

- XER: fixed-point exception register.

- FPS: floating-point status

1. Data movement

- Inside fixed-point unit:

	+ GPR <-> GPR

	+ GPR <-> RAM

- Floating-point unit

	+ FPR <-> FPR

	+ FPR <-> RAM

- Branch unit

	+ bit/field of CR <-> bit/field of CR

- Units

	+ GPR <-> LR, CR, CTR

	+ GPR <-> XER

	+ FPS <-> CTR <-> CR

## History

	Main families: 601(1992), 603, 604, 620(95s)

## Addressing modes

	All instructions have to fit into a single word (32 bits)

- In unconditional branch: 24 bits for addressing ~ +/- 8 million words ~ +/- 32MB

- In conditional branch: 14 bits ~ +/- 8 thousand words ~ +/- 32KB.

	These addresses may by absolute (32KB from top or 32 KB from bottom of stack), or address with offset in range of +/-32KB from a point (current address, TOC, etc...)

	To use absolute address, use `GRP0` (general purpose register 0)

- In case of absolute address:

	+ Positive value: from bottom

	+ Negative: from top

- X-form addressing: uses 2 GPRs, 1 for base, 1 for index.

	+ `GPR0` is used as base register: use absolute 0 value.

	+ `GRP0` is as index: use actual value in register.

##TOC

	Typically contains pointers, addressed using positive offsets from `GPR2`.
