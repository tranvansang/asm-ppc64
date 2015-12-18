#Assembly printf

Support `%d`, `%s`, `%%`, `%c` format.

Basic subroutines:

	- `print_s(char)`: print a char

	- `print_d(int)`: print an integer

	- `print_s(char*)`: print a string

Note:

- Use `ld` and `std` instead of `lwz`, `lbz`, `stw`, `stb`. All basic types (`char`, `int`, `short` ...) are mapped to a `double word` in both `Linux` and `Macintosh` ABIs.

```bash
bash run.sh
```
