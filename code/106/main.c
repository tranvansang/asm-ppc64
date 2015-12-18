#include <stdio.h>
extern char* mystrcat(char *dest, const char *src);
int main(){
	char dest[100] = "Hello, ";
	mystrcat(dest, "World!");
	printf("%s\n", dest);
	return 0;
}
