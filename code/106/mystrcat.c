char* mystrcat(char *dest, const char *src) {
	int dest_len, i;
	for(dest_len = 0; dest[dest_len] != '\0'; dest_len++)
		;

	for (i = 0 ; src[i] != '\0' ; i++)
		dest[dest_len + i] = src[i];
	dest[dest_len + i] = '\0';

	return dest;
}
