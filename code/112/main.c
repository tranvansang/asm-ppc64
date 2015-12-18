#include <stdio.h>
extern int fact(int);
int main(){
	int n = 5;
	printf("Fact(%d) = %d\n", n, fact(n));
	return 0;
}
