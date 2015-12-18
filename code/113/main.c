#include <stdio.h>
extern int fibo(int);
int main(){
	int n = 20;
	printf("Fibo(%d) = %d\n", n, fibo(n));
	return 0;
}

