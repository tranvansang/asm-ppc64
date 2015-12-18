#include <stdio.h>
extern double inner_s(double *, double*);
void show(double *a){
	printf("[%.2lf %.2lf %.2lf %.2lf]\n", a[0], a[1], a[2], a[3]);
}

int main(){
	double a[] = {1.01, 2.3, 3, 4},
		   b[] = {0, 0.2, 0.5, 6.1};
	show(a);
	printf("x\n");
	show(b);
	printf("=\n");
	printf("%.2lf\n", inner_s(a, b));
	return 0;
}
