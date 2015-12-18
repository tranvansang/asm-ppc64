#include <stdio.h>
extern void matmul_s(double*, double*, double*);
int main () {
	int i, j;
	double a[] = {1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4};
	double b[] = {1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4};
	//double a[] = {1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4};
	//double b[] = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1};
	double c[16];
	matmul_s(&a[0], &b[0], &c[0]);
	for(i=0; i<4; i++) {
		for(j=0; j<4; j++)
			printf("%.2f ", c[i*4+j]);
		printf("\n");
	}
	return 0;
}
