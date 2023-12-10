#include <cstdio>
#include <cstring>
#include <unordered_map>
#include <string>
#include <vector>

struct Item {
	Item* left;
	Item* right;
	std::string name = std::string(3, ' ');
};
enum Direction {
	LEFT,
	RIGHT
};
struct MissingItem {
	Item* source;
	std::string dest;
	Direction direction;
};
void addMissingItem(
	Item *source,
	std::string dest,
	std::vector<MissingItem *> &missingItems,
	Direction direction
);

int main() {
	unsigned short count = 0;
	std::unordered_map<std::string, Item*> items;
	std::vector<MissingItem*> missingItems = {};

	FILE* file = fopen("input.txt", "r");
	std::string instructions = "";
	char c;
	while ((c = fgetc(file)) != '\n') {
		instructions += c;
	}
	while ((c = fgetc(file)) != EOF) {
		Item* item = new Item;
		for (int i = 0; i < 3; i++) {
			c = fgetc(file);
			item->name[i] = c;
		}

		fgetc(file);
		fgetc(file);
		fgetc(file);
		fgetc(file);

		std::string leftName = std::string(3, ' ');
		for (int i = 0; i < 3; i++) {
			c = fgetc(file);
			leftName[i] = c;
		}
		auto leftItem = items.find(leftName);
		if (leftItem == items.end()) {
			addMissingItem(item, leftName, missingItems, LEFT);
		}
		else {
			item->left = leftItem->second;
		}

		fgetc(file);
		fgetc(file);
		std::string rightName = std::string(3, ' ');
		for (int i = 0; i < 3; i++) {
			c = fgetc(file);
			rightName[i] = c;
		}
		auto rightItem = items.find(rightName);
		if (rightItem == items.end()) {
			addMissingItem(item, rightName, missingItems, RIGHT);
		}
		else {
			item->right = rightItem->second;
		}
		items[item->name] = item;
		
		fgetc(file);
	}

	for (auto missingItem : missingItems) {
		Item* item = missingItem->source;
		if (missingItem->direction == LEFT) {
			item->left = items[missingItem->dest];
		}
		else {
			item->right = items[missingItem->dest];
		}
		delete missingItem;
	}
	missingItems.clear();
	missingItems.shrink_to_fit();

	Item* current = items["AAA"];
	items.clear();
	while (current->name != "ZZZ") {
		for (char instruction : instructions) {
			if (instruction == 'L') {
				current = current->left;
			}
			else {
				current = current->right;
			}
			count++;
			if (current->name == "ZZZ") {
				break;
			}
		}
	}

	printf("%d\n", count);
	return 0;
}

void addMissingItem(
	Item *source,
	std::string dest,
	std::vector<MissingItem *> &missingItems,
	Direction direction
) {
	missingItems.push_back(new MissingItem {
		source,
		dest,
		direction
	});
}
