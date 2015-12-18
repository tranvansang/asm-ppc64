#include <stdio.h>
extern int mystrcmp2(char *a, char *b);
int main(){
	char a[] = "Hello, world";
	char b[] = "Hello, seikai";
	int t = mystrcmp2(a, b);
	printf("\"%s\" %s \"%s\"\n", a,
			t == 0 ? "=" : t < 0 ? "<" : ">",
			b
		  );
	return 0;
}
