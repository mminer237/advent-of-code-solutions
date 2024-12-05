#!/usr/bin/env node

const fs = require('fs');
const readline = require('readline');

let sum = 0;
const lineReader = readline.createInterface({
	input: fs.createReadStream('input.txt')
});
lineReader.on('line', line => {
	const nums = line.split(' ');
	let overallIncreasing;
	for (let i = 0; i + 1 < nums.length; i++) {
		const difference = nums[i + 1] - nums[i];
		if (difference === 0)
			return;
		const increasing = difference > 0;
		if (overallIncreasing === undefined)
			overallIncreasing = increasing
		else if (overallIncreasing !== increasing)
			return;
		if (Math.abs(difference) > 3)
			return;
	}
	sum++;
}).on('close', function () {
	console.log(sum);
});