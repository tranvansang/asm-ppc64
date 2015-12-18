#include <stdio.h>
extern int ackermann(int, int);
int main(){
	int m = 3;
	int n = 4;
	printf("ackermann(%d, %d) = %d\n", m, n, ackermann(m, n));
	return 0;
}
