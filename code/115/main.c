#include <stdio.h>
extern void add128(unsigned long long int*, unsigned long long int*, unsigned long long int*);

void show(unsigned long long int* a){
	printf("[%#018llx, %#018llx]\n", a[0], a[1]);
}

int main(){
	unsigned long long int a[2] = {0x1ULL, 0xFFFFFFFFFFFFFFFFULL},
				  b[2] = {0x8ULL, 0x9ULL}, c[2];
	printf("   ");
	show(a);
	printf(" + ");
	show(b);
	printf(" = ");
	add128(a, b, c);
	show(c);
	return 0;
}
