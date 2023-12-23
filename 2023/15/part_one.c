#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

int main() {
	int sum = 0;
	FILE* file = fopen("input.txt", "r");
	char c;
	int currentValue = 0;
	while ((c = fgetc(file)) != EOF) {
		if (c != '\n') {
			if (c != ',') {
				currentValue += c;
				currentValue *= 17;
				currentValue %= 256;
			}
			else {
				sum += currentValue;
				currentValue = 0;
			}
		}
	}
	fclose(file);
	sum += currentValue;

	printf("%d\n", sum);

	return 0;
}