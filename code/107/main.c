#include <stdio.h>
extern mystrcmp(char *sa, char *sb);
int main(){
	char sa[] = "hello, world";
	char sb[] = "hello, universal";
	int t = mystrcmp(sa, sb);
	printf("%s %s %s\n", sa, t < 0 ? "<" : t > 0 ? ">" : "=", sb);
	return 0;
}
