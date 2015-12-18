#!/bin/bash
gcc main.c print_d.s print.s print_s.s print_c.s strlen.s
./a.out
#result
#A normal string
#Escape percentage char: %
#Escape 10 integers: 1 2 3 4 5 -5 -4 -3 -2 -1
#Escape 5 strings: This is a parameter string
#Do not escape parameter: this %s (percentage-s) or %d (percentage-d) and %% (double percentages) should not be escaped
#Escape 13 characters: Hello, world!
#Four consecutive percentages should show 2: %%
#Invalid escapes: %_d%u%m%p
#And a perecentage at end of string: %
