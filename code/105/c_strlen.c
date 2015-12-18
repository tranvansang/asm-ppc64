int c_strlen(char *str){
	int i = 0;
	while(1){
		if (str[i] == '\0')break;
		i++;
	}
	return i;
}
