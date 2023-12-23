#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Lens {
	char label[7];
	int focalLength;
	struct Lens* next;
};

int main() {
	int sum = 0;
	struct Lens boxes[256] = {};
	FILE* file = fopen("input.txt", "r");
	char c;
	bool readFocalLength = false;
	char label[7];
	int labelIndex = 0;
	int currentValue = 0;
	while ((c = fgetc(file)) != EOF) {
		if (c != '\n') {
			if (readFocalLength) {
				readFocalLength = false;
				struct Lens* lens = &boxes[currentValue];
				while (true) {
					// printf("A? %d %s=%d %p\n", currentValue, lens->label, lens->focalLength, lens->next);
					if (
						lens->label[0] == 0 ||
						lens->label[0] == '\0' ||
						strcmp(lens->label, label) == 0
					) {
						break;
					}
					if (lens->next == NULL) {
						lens->next = malloc(sizeof(struct Lens));
						lens = lens->next;
						lens->next = NULL;
						break;
					}
					lens = lens->next;
				}
				strcpy(lens->label, label);
				lens->focalLength = c - '0';
				// printf("A! %d %s=%d %p\n", currentValue, lens->label, lens->focalLength, lens->next);
			}
			else {
				switch (c) {
					case '=':
						readFocalLength = true;
						label[labelIndex] = '\0';
						break;
					case '-':
						label[labelIndex] = '\0';
						struct Lens* priorLens = NULL;
						struct Lens* lens = &boxes[currentValue];
						do {
							// printf("R? %d %s=%d %p\n", currentValue, lens->label, lens->focalLength, lens->next);
							if (strcmp(lens->label, label) == 0) {
								// printf("R! %d %s=%d %p\n", currentValue, lens->label, lens->focalLength, lens->next);
								if (priorLens != NULL) {
									priorLens->next = lens->next;
									free(lens);
								}
								else if (lens->next != NULL) {
									strcpy(lens->label, lens->next->label);
									lens->focalLength = lens->next->focalLength;
									struct Lens* toDelete = lens->next;
									lens->next = lens->next->next;
									free(toDelete);
								}
								else {
									lens->label[0] = '\0';
									lens->focalLength = 0;
								}
								break;
							}
						} while ((lens = lens->next) != NULL);
						break;
					case ',':
						labelIndex = 0;
						currentValue = 0;
						break;
					default:
						label[labelIndex] = c;
						labelIndex++;
						currentValue += c;
						currentValue *= 17;
						currentValue %= 256;
						break;
				}
			}
		}
	}
	fclose(file);
	
	for (int i = 0; i < 256; i++) {
		struct Lens* lens = &boxes[i];
		int slot = 1;
		do {
			if (lens->focalLength != 0) {
				// printf("%d %d %s=%d\n", i, slot, lens->label, lens->focalLength);
				sum += (i + 1) * lens->focalLength * slot++;
			}
		} while ((lens = lens->next) != NULL);
	}

	printf("%d\n", sum);

	return 0;
}