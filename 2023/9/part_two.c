#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

int processNumbers(long numbers[], unsigned int length);

void addNumber (
	char buffer[12],
	unsigned int* bufferIndex,
	long numbers[21],
	unsigned int* numberIndex
);

int main() {
	int sum = 0;
	FILE* file = fopen("input.txt", "r");
	char c;
	long numbers[21];
	char buffer[12];
	unsigned int numberIndex = 20;
	unsigned int bufferIndex = 0;
	while ((c = fgetc(file)) != EOF) {
		if (c != '\n') {
			if (c == ' ') {
				addNumber(buffer, &bufferIndex, numbers, &numberIndex);
			}
			else {
				buffer[bufferIndex++] = c;
			}
		}
		else {
			addNumber(buffer, &bufferIndex, numbers, &numberIndex);

			sum += processNumbers(numbers, 21);

			numberIndex = 20;
			bufferIndex = 0;
		}
	}
	fclose(file);

	printf("%d\n", sum);

	return 0;
}

void addNumber(
	char buffer[12],
	unsigned int* bufferIndex,
	long numbers[21],
	unsigned int* numberIndex
) {
	buffer[*bufferIndex] = '\0';
	numbers[(*numberIndex)--] = strtol(buffer, NULL, 10);
	*bufferIndex = 0;
}

int processNumbers(long numbers[], unsigned int length) {
	unsigned int i;
	long offsets[length - 1];

	bool allZero = true;
	for (i = 0; i < length - 1; i++) {
		offsets[i] = numbers[i + 1] - numbers[i];
		if (offsets[i] != 0) {
			allZero = false;
		}
	}
	if (allZero) {
		return numbers[length - 1];
	}
	else {
		int newOffset = processNumbers(offsets, length - 1);
		long newNumber = numbers[length - 1] + newOffset;
		return newNumber;
	}
}