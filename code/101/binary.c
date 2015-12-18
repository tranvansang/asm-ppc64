#include <stdio.h>
#include <stdint.h>

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

void binary_byte(uint8_t c, char *s){
	int i;
	for(i = 7; i >= 0; i--){
		s[i] = '0' + (c & 1);
		c >>= 1;
	}
}
char *to_binary(int32_t n, char * s, int is_big_end){
	uint32_t un = (uint32_t) n;
	int i;
	if (is_big_end){
		for(i = 3; i >= 0; i--){
			binary_byte(un & ((1 << 8) - 1), s + i * 9);
			if (i != 0)
				s[i * 9 - 1] = ' ';
			un >>= 8;
		}
	}else{
		for(i = 0; i < 4; i++){
			binary_byte(un & ((1 << 8) - 1), s + i * 9);
			if (i != 0)
				s[i * 9 - 1] = ' ';
			un >>= 8;
		}
	}
	s[4 * 9 - 1] = '\0';
	return s;
}
int main(){
	printf("Enter n: ");
	int n;
	char s[100];
	scanf("%d", &n);
	printf("Bit pattern of %d in    big-endian is: %s\n", n, to_binary(n, s, 1));
	printf("Bit pattern of %d in little-endian is: %s\n", n, to_binary(n, s, 0));
	int detect = detect_endian();
	printf("Detect endianness of your PC's architecture: %s\n", detect == 0 ? "undefined" : (detect == 1 ? "little-endian" : "big-endian"));
	return 0;
}

