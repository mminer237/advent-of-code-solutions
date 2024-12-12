#!/usr/bin/env node

const fs = require('fs');

let count = 0;
const input = fs.readFileSync('input.txt', 'utf8').split('\n');
for (let li = 0; li < input.length; li++) {
	for (let ci = 0; ci < input[li].length; ci++) {
		if (input[li][ci] === 'A') {
			const tl = input[li - 1]?.[ci - 1];
			const tr = input[li - 1]?.[ci + 1];
			const bl = input[li + 1]?.[ci - 1];
			const br = input[li + 1]?.[ci + 1];
			const letters = [tl, tr, bl, br];
			if (
				letters.filter(c => c === 'M').length === 2 &&
				letters.filter(c => c === 'S').length === 2 &&
				(tl === tr || tl === bl)
			) {
				// console.log(`${tl??' '}.${tr??' '}\n.${input[li][ci]}.\n${bl??' '}.${br??' '}\n`);
				count++;
			}
		}
	}
}
console.log(count);
