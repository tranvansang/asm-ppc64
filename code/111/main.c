#include <stdio.h>
extern int double_sign(double);
extern int double_exponent(double);
extern int double_mantissa(double);
int main(){
	double f = -332.00231;
	printf("Double value: %f\n", f);
	printf("Sign: %d\n", double_sign(f));
	printf("Exponent: %d\n", double_exponent(f));
	printf("Mantissa: %d\n", double_mantissa(f));
	return 0;
}
