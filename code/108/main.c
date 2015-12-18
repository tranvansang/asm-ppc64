#include <stdio.h>
extern int maxof3(int a, int b, int c);
int main(){
	int a = 98765432, b = 123123123, c = 12322;
	printf("Max of %d, %d, and %d is %d\n", a, b, c, maxof3(a, b, c));
	return 0;
}
