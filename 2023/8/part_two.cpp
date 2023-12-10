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
	std::unordered_map<std::string, Item*> items;
	std::vector<MissingItem*> missingItems = {};
	std::vector<Item*> aNodes = {};
	std::vector<Item*> zNodes = {};

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

		if (item->name[2] == 'A') {
			aNodes.push_back(item);
		}
		else if (item->name[2] == 'Z') {
			zNodes.push_back(item);
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
	items.clear();

	std::vector<Item*> current = aNodes;
	std::vector<unsigned int> spacings;
	for (unsigned int i = 0; i < current.size(); i++) {
		unsigned int count = 0;
		while (current[i]->name[2] != 'Z') {
			for (char instruction : instructions) {
				if (instruction == 'L') {
					current[i] = current[i]->left;
				}
				else {
					current[i] = current[i]->right;
				}
				count++;
			}
		}
		spacings.push_back(count);
	}
	std::unordered_map<unsigned int, unsigned int> factors;
	for (unsigned int i = 0; i < spacings.size(); i++) {
		unsigned int factor = 2;
		std::unordered_map<unsigned int, unsigned int> localFactors;
		while (factor * factor <= spacings[i]) {
			if (spacings[i] % factor == 0) {
				spacings[i] /= factor;
				if (localFactors[factor] == 0) {
					localFactors[factor] = 1;
				}
				else {
					localFactors[factor]++;
				}
			}
			else {
				factor++;
			}
		}
		if (factor > 1) {
			if (localFactors[spacings[i]] == 0) {
				localFactors[spacings[i]] = 1;
			}
			else {
				localFactors[spacings[i]]++;
			}
		}

		for (auto localFactor : localFactors) {
			if (factors[localFactor.first] < localFactor.second) {
				factors[localFactor.first] = localFactor.second;
			}
		}
	}
	unsigned long long result = 1;
	for (auto factor : factors) {
		for (unsigned int i = 0; i < factor.second; i++) {
			result *= factor.first;
		}
	}
	printf("%llu\n", result);
	
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
