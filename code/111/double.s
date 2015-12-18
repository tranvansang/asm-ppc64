.include "lib.s"
.global double_sign
.global double_exponent
.global double_mantissa

.set value, 3
.set m_size, 52
.set e_size, 11
.set s_size, 1

double_sign:
	param_on_stack "stfd %f1, ", 1
	param_on_stack "ld value, ", 1
	extrdi value, value, 1, 0
	blr

double_exponent:
	param_on_stack "stfd %f1, ", 1
	param_on_stack "ld value, ", 1
	rotrdi value, value, m_size
	clrldi value, value, (s_size + m_size)
	blr

double_mantissa:
	param_on_stack "stfd %f1, ", 1
	param_on_stack "ld value, ", 1
	clrldi value, value, (e_size + s_size)
	blr
