#include <stdio.h>
extern mystrcat2(char *a, char * b);
int main(){
	char a[100] = "Hello, ";
	char b[] = "world";
	printf("\"%s\" + \"%s\" = ", a, b);
	printf("\"%s\"\n", mystrcat2(a, b));
	return 0;
}
