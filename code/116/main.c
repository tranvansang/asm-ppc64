#include <stdio.h>
extern void mul128(unsigned long long int*, unsigned long long int*, unsigned long long int*);

void show(unsigned long long int* a, int cnt){
	printf("[");
	int i;
	for(i = 0; i < cnt; i++)
		printf("%#018llx%s", a[i], i < cnt - 1 ? ", ": "");
	printf("]\n");
}

int main(){
	//unsigned long long int a[2] = {0x1000000000000000ULL, 0x1000000000000000ULL}, b[2] = {0x8ULL, 0x9ULL}, c[4];
	unsigned long long int a[2] = {0xFFFFFFFFFFFFFFFFULL, 0xFFFFFFFFFFFFFFFFULL},
				  b[2] = {0xFFFFFFFFFFFFFFFFULL, 0xFFFFFFFFFFFFFFFFULL}, c[4];
	printf("   ");
	show(a, 2);
	printf(" + ");
	show(b, 2);
	printf(" = ");
	mul128(a, b, c);
	show(c, 4);
	return 0;
}
