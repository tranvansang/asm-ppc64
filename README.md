#Assembly on ppc64 structure computer

##Host info

`uname -a`’s result:

> Linux csp 2.6.32.36-0.5-ppc64 #1 SMP 2011-04-14 10:12:31 +0200 ppc64 ppc64 ppc64 GNU/Linux

###GCC compiling

- Compile `.c` file to assembly `.s` file: `gcc test.c -S`

- Show register name: `-mregnames`

- Optimize code: `-O<level>`
	
	+ `-O0`: no optimize.

	+ `-O`: default level.

##GDB usage

```bash
gdb a.out
break *main
run
layout asm
```

- Break at address: `break *<label name>+<offset>`

- Continue: `c`

- Step: `stepi`

- Show register value: `info reg [reg name]`

- Print in binary format:

	+ `p /t $r3`: print register `r3` in binary format

	+ `x /t $r3`: examine

	+ `p (char)*0xffff0122`: print memory at ... as char value

##Disassembler object file

- On Mac: `otool -tV`

- On Linux:

	+ Install `binutil`

	+ Use `objdump -d -M intel -S test.o`

- Using `gdb`: `disas /m main`


##Building cross compiler

- `gcc`’s compiling option `-host`: compiling computer’s structure

- `gcc`’s compiling option `-target`: result file’s platform to compile to

###Build from window:

Use `pearlpc` from [here](http://www.mediafire.com/download/7vhn1l49405jfcr/MacOSX102PearPC.7z) or [here](http://pearpc.sourceforge.net/downloads.html)

###Build from Mac

- Using native `clang`

	+ List supported architecture in current Mac:

	```bash
	ls /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/libexec/as/
	```

	+ Then compile with `as <input file.c> arch <arch-name>`

- Success build usage from [Stackoverflow](http://stackoverflow.com/questions/5333490/how-can-we-restore-ppc-ppc64-as-well-as-full-10-4-10-5-sdk-support-to-xcode-4
http://blog.laurent.etiemble.com/index.php?post/2011/09/04/Xcode-3.2.6,-Lion-and-PPC-support), hack to `Xcode`

	+ On newer version of Mac. See [here](http://stackoverflow.com/questions/7137480/how-do-i-add-ppc-ppc64-support-back-to-xcode-4-2-under-lion)

###From linux

See [this usage](http://kivantium.hateblo.jp/entry/2015/12/05/003905) (in Japanese)

###Other

Useful references

- [How to build a gcc cross compiler](http://preshing.com/20141119/how-to-build-a-gcc-cross-compiler/)

- [osdev’s gcc cross compiler](http://wiki.osdev.org/GCC_Cross-Compiler)

- [gcc -march option](https://wiki.gentoo.org/wiki/GCC_optimization#-march)

- [clang cross compiling](http://clang.llvm.org/docs/CrossCompilation.html)

- [General wiki page](https://en.wikipedia.org/wiki/Cross_compiler)

- [other](https://www.ffmpeg.org/platform.html)

- [other](http://www.linuxtopia.org/online_books/an_introduction_to_gcc/gccintro_62.html)

- [other](https://gcc.gnu.org/install/specific.html#powerpcle-x-eabi)

- [macemu](https://github.com/cebix/macemu)

- [gcc](https://gcc.gnu.org/ml/gcc/2005-10/msg00981.html)

- [crossgcc](https://sourceware.org/ml/crossgcc/2015-12/msg00005.html)

- [crosstool-ng](http://crosstool-ng.org/): list of `gcc`’s `configure` options to build cross `gcc` on host.

- [crosstool’s doc](http://kegel.com/crosstool/current/doc/crosstool-howto.html)

- [Clang official cross compilation doc](http://clang.llvm.org/docs/CrossCompilation.html)

- [Clang official doc](http://llvm.org/docs/HowToCrossCompileLLVM.html)

- [llvm-dev](http://lists.llvm.org/pipermail/llvm-dev/2015-July/087863.html)

- [osdev](http://wiki.osdev.org/LLVM_Cross-Compiler)

- [gcc](https://gcc.gnu.org/install/specific.html#powerpc-x-linux-gnu)

- [llvm clang target](http://llvm.org/devmtg/2014-04/PDFs/LightningTalks/2014-3-31_ClangTargetSupport_LighteningTalk.pdf)

- [Add new target to clang](http://clang-developers.42468.n3.nabble.com/How-to-add-new-target-td462332.html)

- [clang-dev](http://comments.gmane.org/gmane.comp.compilers.clang.devel/39896)

- [clang user manual](http://clang.llvm.org/docs/UsersManual.html#x86)

##Some notes

- Type’s size

|Type|Size (bit)|
|----|:----------:|
|Byte|8|
|Half word| 16|
|Word | 32|
|Double word | 64|
|Quad word | 128|

- In function is directed called from `main`, parameter list is not saved in linkage area (offset 48 from stack pointer)

##Programming practise

- Use macro.

	There are 2 styles of macro

	+ Apple’s style: using `.macro` and `.endmacro`, supports 10 parameters: `$0` to `$9`, with number of arguments is `$n`

	+ GNU’s style: using `.macro <argument list>` and `.endm`

	+ Combine with `.if`, `.else`, `.endif` for more efficiency.

	+ See `lib.s` for more useful macros.

	+ Example:

```asm

```

- Use constant with meaningful name

For example:

```asm
.set param_area, 48
#or
frame_size = 112
.set my_arg, 3 #%r3
sp = 1 #%r1
stw my_arg, param_area(sp)
```

- Use comment:

```asm
# GNU comment style
; Apple comment style
// Apple comment style
/* Another GNU comment style */
```

## Document

- [Function calling convention][apple-calling-convention] (Apple)

- [Language reference by Apple][apple-reference]

- [Using `isel`, `fsel` to reduce number of branch instruction][isel-doc]

- [Short list of instructions and usage][sumary]

- [A deep understanding book](http://physinfo.ulb.ac.be/divers_html/powerpc_programming_info/intro_to_ppc/ppc0_index.html)

- GNU assembler syntax reference manual: [official](https://sourceware.org/binutils/docs/as/), or [mirror](http://tigcc.ticalc.org/doc/gnuasm.html)


[apple-calling-convention]: https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/LowLevelABI/110-64-bit_PowerPC_Function_Calling_Conventions/64bitPowerPC.html#//apple_ref/doc/uid/TP40002471-SW13
[apple-reference]: https://developer.apple.com/library/mac/documentation/DeveloperTools/Reference/Assembler/050-PowerPC_Addressing_Modes_and_Assembler_Instructions/ppc_instructions.html#//apple_ref/doc/uid/TP30000824-TPXREF104
[isel-doc]: https://www.rapitasystems.com/blog/interesting-microcontroller-features-powerpc-isel-instruction
[sumary]: http://www.ds.ewi.tudelft.nl/vakken/in101/labcourse/instruction-set/
