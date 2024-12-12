#include <stdbool.h>
#include <stdio.h>

int main() {
	int sum = 0;
	FILE *fp1 = fopen("input.txt", "r");
	FILE *fp2 = fopen("input.txt", "r");
	fseek(fp2, 0, SEEK_END);
	int length = ftell(fp2) - 1;
	fseek(fp2, -(length / 2 + 1), SEEK_CUR);
	char c1, c2;
	while ((c2 = fgetc(fp2)) != EOF && c2 != '\n') {
		c1 = fgetc(fp1);
		if (c1 == c2) {
			sum += (c1 - '0') * 2;
		}
	}
	fclose(fp1);
	fclose(fp2);

	printf("%d\n", sum);

	return 0;
}