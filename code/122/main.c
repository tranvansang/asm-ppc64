int main(){
	print("A normal string\nEscape percentage char: %%\nEscape 10 integers: %d %d %d %d %d %d %d %d %d %d\nEscape 5 strings: %s %s %s %s %s\nDo not escape parameter: %s\nEscape 13 characters: %c%c%c%c%c%c%c%c%c%c%c%c%c\nFour consecutive percentages should show 2: %%%%\nInvalid escapes: %_d%u%m%p\nAnd a perecentage at end of string: %",
			1, 2, 3, 4, 5, -5, -4, -3, -2, -1,
			"This", "is", "a", "parameter", "string",
			"this %s (percentage-s) or %d (percentage-d) and %% (double percentages) should not be escaped",
			'H', 'e', 'l', 'l', 'o', ',', ' ', 'w', 'o', 'r', 'l', 'd', '!');
	return 0;
}
