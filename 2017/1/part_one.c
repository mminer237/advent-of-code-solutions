#include <stdbool.h>
#include <stdio.h>

int main() {
	int sum = 0;
	FILE* file = fopen("input.txt", "r");
	char first = fgetc(file);
	ungetc(first, file);
	char c;
	char pc = 0;
	while ((c = fgetc(file)) != EOF && c != '\n') {
		if (c == pc && c >= '0' && c <= '9') {
			sum += c - '0';
		}
		pc = c;
	}
	fclose(file);
	if (pc == first) {
		sum += first - '0';
	}

	printf("%d\n", sum);

	return 0;
}