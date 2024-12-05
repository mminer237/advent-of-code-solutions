#!/usr/bin/env node

const fs = require('fs');
const readline = require('readline');

let sum = 0;
const lineReader = readline.createInterface({
	input: fs.createReadStream('input.txt')
});
lineReader.on('line', line => {
	const nums = line.split(' ');
	const r = !!testLine(nums);
	sum += r;
}).on('close', function () {
	console.log(sum);
});

function testLine(nums, i = 1, dampened = false, skip = 0, overallIncreasing = null) {
	for (; i < nums.length; i++) {
		if (i == 1 && skip) {
			skip = 0;
			continue;
		}
		const difference = nums[i] - nums[i - 1 - skip];
		if (difference === 0) {
			if (!dampened) {
				dampened = true;
				continue;
			}
			else {
				if (skip && i > 1) {
					return testLine(nums, i - 1, true, 1, overallIncreasing);
				}
				return false;
			}
		}
		const increasing = difference > 0;
		if (overallIncreasing === null)
			overallIncreasing = increasing;
		else if (overallIncreasing !== increasing)
			if (!dampened) {
				return testLine(nums, i, true, 1, (i === 2) ? nums[i] - nums[i - 2] > 0 : overallIncreasing) ||
				       (i === 2 && testLine(nums, i, true, 0, nums[i] - nums[i - 1] > 0)) ||
				       testLine(nums, i + 1, true, 1, overallIncreasing);
			}
			else
				return false;
		if (Math.abs(difference) > 3)
			if (!dampened) {
				dampened = true;
				if (i === 1)
					return testLine(nums, i + 1, true, 1, nums[nums.length - 1] - nums[i + 1] > 0) ||
					       testLine(nums, i + 1, true, 0, nums[nums.length - 1] - nums[i + 1] > 0);
				skip = 1;
				continue;
			}
			else
				return false;
		skip = 0;
	}
	return true;
}