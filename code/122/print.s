.include "macro.s"

percentage = '%'
escape_percentage = '%'
escape_integer = 'd'
escape_string = 's'
escape_character = 'c'

declare arg_on_stack
declare string_on_stack

arg = r4
current_char = r5
string = r6

size_of_int = dword_length
#note, when passed as paramter, these types are mapped to a double word.
#Sign bits are also extended for signed number
size_of_char = dword_length
size_of_string = 8

#current state includes: string, arg
.macro backup_state
	std arg, arg_on_stack(sp)
	std string, string_on_stack(sp)
.endm

.macro restore_state
	ld arg, arg_on_stack(sp)
	ld string, string_on_stack(sp)
.endm

.global print
print:
#force save all params to linkage_area
	backup_param 1, 8
	backup_lr
	setup_frame

	addi arg, sp, size_of_string + frame_size + stack_param_area
	mr string, param_reg_1


loop_string:
	lbz current_char, 0(string)
#end of string
	cmpi %cr7, current_char, 0
	beq- %cr7, return

#a % without %-preceded. or the preceding-% was escaped by another precedence (Ex.: %%%)
	cmpi %cr7, current_char, percentage
	beq- %cr7, have_pct

#just normal char
	backup_state
	mr param_reg_1, current_char
	bl print_c
	restore_state

#go next
	inc string
	b loop_string

have_pct:
	inc string
	lbz current_char, 0(string)
#end of string: an error from user. Just show percentage
	cmpi %cr7, current_char, 0
	bne+ %cr7, not_end_of_string
	li param_reg_1, percentage
	bl print_c
	b return
not_end_of_string:
	inc string

#an integer (escape_integer)
	cmpi %cr7, current_char, escape_integer
	bne- %cr7, not_integer
#NOTE: use ld instead of lwz
	ld param_reg_1, 0(arg)
	inc arg, size_of_int
	backup_state
	bl print_d
	restore_state
	b loop_string
not_integer:

#a string (escape_string)
	cmpi %cr7, current_char, escape_string
	bne- %cr7, not_string
	ld param_reg_1, 0(arg)
	inc arg, size_of_string
	backup_state
	bl print_s
	restore_state
	b loop_string
not_string:

#a character (escape_character)
	cmpi %cr7, current_char, escape_character
	bne+ %cr7, not_character
#note: use ld, not lbz
	ld param_reg_1, 0(arg)
	inc arg, size_of_char
	backup_state
	bl print_c
	restore_state
	b loop_string
not_character:

#another percentage (escape_percentage)
	cmpi %cr7, current_char, escape_percentage
	bne+ %cr7, not_percentage
	backup_state
	li param_reg_1, percentage
	bl print_c
	restore_state
	b loop_string
not_percentage:

#else: an error from user's input. show both % and current char
	backup_state
	li param_reg_1, percentage
	bl print_c
#reload current_char. note: string has already increased for next loop
	restore_state #note: only restore, not need to backup again here
	lbz param_reg_1, -1(string)
	bl print_c
	restore_state
	b loop_string

return:
	restore_frame
	restore_lr
	blr
