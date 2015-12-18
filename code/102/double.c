#include <stdio.h>
#include <math.h>
#include <stdint.h>

void show(double f, const char* str);

/**
 * detect endian (big or litte)
 * @result: -1 if big-endian, 1 if little-endia, 0 otherwise
 */
int detect_endian(){
	uint8_t  x[2];
	*((uint16_t*)x) = 1;
	if (x[0] == 0 && x[1] == 1)
		return -1;
	if (x[0] == 1 && x[1] == 0)
		return 1;
	return 0;
}

void byte_to_string(uint8_t c, char *s){
	int i;
	for(i = 7; i >= 0; i--){
		s[i] = '0' + (c & 1);
		c >>= 1;
	}
}
void byte_array_to_string(uint8_t *a, int size, char *s){
	int i;
	for(i = 0; i < size; i++){
		byte_to_string(a[i], s + i * 9);
		if (i != 0)
			s[i * 9 - 1] = ' ';
	}
	s[size * 9 - 1] = '\0';
}

void byte_array_reserve(uint8_t *a, int size){
	int i;
	for(i = 0, size = size - 1; i < size; i++, size--){
		uint8_t tmp = a[i];
		a[i] = a[size];
		a[size] = tmp;
	}
}

void bit_array_to_byte_array(uint8_t *input, int size_in_byte, uint8_t *output){
	int i, j;
	for(i = 0; i < size_in_byte; i++){
		output[i] = 0;
		for(j = 0; j < 8; j++) {
			output[i] <<= 1;
			output[i] += input[i * 8 + j];
		}
	}
}

void double_to_bit_array_diy_big(double f, uint8_t *bit_array){
	int top;
	if (f  == 0){//0
		for(top = 1; top < 64; top++)
			bit_array[top] = 0;
		//check sign
		bit_array[0] = 1 / f > 0 ? 0 : 1;
	}else if (f == INFINITY){//inf
		bit_array[0] = 0;
		for(top = 1; top < 12; top++)
			bit_array[top] = 1;
		for(top = 12; top < 64; top++)
			bit_array[top] = 0;
	}else if (f == -INFINITY){//inf
		for(top = 0; top < 12; top++)
			bit_array[top] = 1;
		for(top = 12; top < 64; top++)
			bit_array[top] = 0;
	}else if (f != f){//nan. take any representation with signed = 0, exponent = 0x7ff (max), mantissa != 0
		for(top = 0; top < 64; top++)
			bit_array[top] = 1;
	}else{
		if (f < 0){
			f = -f;
			bit_array[0] = 1;
		}else{//positive
			bit_array[0] = 0;
		}

		//check subnormal
		int tmp = 1023;
		double subn_thres = 2;
		while(tmp--)
			subn_thres /= 2;
		if (f < subn_thres){
			tmp = 1022;
			while(tmp--)
				f *= 2;
			//fill exponent
			for(top = 1; top < 12; top++)
				bit_array[top] = 0;
			for(top = 12; top < 64; top++){
				bit_array[top] = f * 2 >= 1 ? 1 : 0;
				f *= 2;
				if (f >= 1)
					f-= 1;
			}
			return;
		}
		/* get exponent: next 11 bits*/
		int e = 0;
		while (f >= 2){
			f /= 2;
			e++;
		}
		while(f < 1){
			f *= 2;
			e--;
		}
		e += 1023;
		for(top = 11; top> 0; top--){
			bit_array[top] = e & 1;
			e >>= 1;
		}

		/* get mantissa */
		f -= 1;
		for(top = 12; top < 64; top++){
			bit_array[top] = f * 2 >= 1 ? 1 : 0;
			f *= 2;
			if (f >= 1)
				f -= 1;
		}
	}
}

void byte_array_to_bit_array(uint8_t *byte_array, size_t size, uint8_t *bit_array){
	int i;
	for(i = 0; i < size; i++){
		uint8_t t = byte_array[i];
		int j;
		for(j = 8 * i + 7; j >= 8 * i; j--){
			bit_array[j] = t & 1;
			t >>= 1;
		}
	}
}
void double_to_bit_array_diy_little(double f, uint8_t *bit_array){
	uint8_t byte_array[8];
	bit_array_to_byte_array(bit_array, 8, byte_array);
	byte_array_reserve(byte_array, 8);
	byte_array_to_bit_array(byte_array, 8, bit_array);
}

void double_to_bit_array_native(double f, uint8_t *bit_array){
	uint8_t a[8];
	*((double*)a) = f;
	byte_array_to_bit_array(a, 8, bit_array);
}

double bit_array_to_double_diy_big(uint8_t *bit_array){
	//sign
	int sign = bit_array[0];

	//exponent
	int exponent = 0;
	int i;
	for(i = 1; i < 12; i++){
		exponent <<= 1;
		exponent += bit_array[i];
	}

	//mantissa
	double m = 0;
	for(i = 63; i  >= 12; i--){
		m += bit_array[i];
		m /= 2;
	}
	m = 0.5;

	if (exponent == 0){
		if (m == 0)
			return sign == 0 ? 0.0 : -0.0;
		i = 1022;
		while(i--){
			m /= 2;
			//show(m, "test");
		}
		return sign == 1 ? -m : m;
		//subnormal
	}else
		if (exponent == 0x7ff){
			if (m == 0)
				return sign == 1 ? -INFINITY : INFINITY;
			return NAN;
		}else{
			double f = 1;
			int tmp = exponent - 1023;
			for(i = 0; i < tmp; i++)
				f *= 2;
			for(i = 0; i > tmp; i--)
				f /= 2;
			f *= sign == 0 ? 1 : -1;
			f *= (1. + m);
			return f;
		}
}

double bit_array_to_double_diy_little(uint8_t *bit_array){
	uint8_t byte_array[8];
	uint8_t bb_array[64];
	bit_array_to_byte_array(bit_array, 8, byte_array);
	byte_array_reserve(byte_array, 8);
	byte_array_to_bit_array(byte_array, 8, bb_array);
	return bit_array_to_double_diy_big(bb_array);
}

double bit_array_to_double_native(uint8_t *bit_array){
	double f;
	uint8_t byte_array[8];
	bit_array_to_byte_array(bit_array, 8, byte_array);
	if (detect_endian() == 1)//little
		byte_array_reserve(byte_array, 8);
	f = *((double*)byte_array);
	return f;
}

void show(double f, const char* str){
	//data
	char s[100];
	uint8_t bit[64], byte[8];

	printf("Bit representation of %.20lf (%s):\n", f, str);

	//native
	double_to_bit_array_native(f, bit);
	bit_array_to_byte_array(bit, 8, byte);
	byte_array_to_string(byte, 8, s);
	printf("Native (current computer structure):\n%s\n", s);

	//diy big
	double_to_bit_array_diy_big(f, bit);
	bit_array_to_byte_array(bit, 8, byte);
	byte_array_to_string(byte, 8, s);
	printf("DIY in big endian: \n%s\n", s);

	puts("");

}

int main(){
	int detect = detect_endian();
	printf("Detect endianness of your PC's architecture: %s\n\n", detect == 0 ? "undefined (force little endian)" : (detect == 1 ? "little-endian" : "big-endian"));

	show(sqrt(-1), "sqrt(-1)");//nan
	double t = 0.;
	show(1./t, "1/0"); //infinity
	show(log(0), "log(0)");//-infinity
	show(0.0, "0.0");
	show(-0.0, "-0.0");
	show(1.0, "1.0");
	show(0.1, "0.1");
	printf("The smallest positive number\n");
	uint8_t min_pos[] = {0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1};//2^(-1022 - 52);
	show(bit_array_to_double_native(min_pos), "native converter from bit array");
	show(bit_array_to_double_diy_big(min_pos), "diy converter from bit array");

	printf("The smallest positive number greater than 1\n");
	uint8_t min_gt_1_pos[] = {0,
		0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1};
		//1 + 2^(-52);
	show(bit_array_to_double_native(min_gt_1_pos), "native converter from bit array");
	show(bit_array_to_double_diy_big(min_gt_1_pos), "diy converter from bit array");


	//user enter
	double f;
	printf("Enter a double: ");
	scanf("%lf", &f);
	show(f, "user's input");

	return 0;
}

