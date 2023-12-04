#!/usr/bin/env node

const fs = require('fs');
const readline = require('readline');

let sum = 0;
let streaks = [];
const lineReader = readline.createInterface({
	input: fs.createReadStream('input.txt')
});
lineReader.on('line', function (line) {
	const copies = streaks.reduce((a, x) => a + x.copies, 1);
	sum += copies;
	streaks.forEach(x => x.remaining--);
	streaks = streaks.filter(x => x.remaining > 0);
	line = line.split(/ +/);
	const pipe = line.indexOf('|');
	const winners = new Set(line.slice(2, pipe).map(Number));
	let matches = 0;
	for (const n of line.slice(pipe + 1).map(Number)) {
		if (winners.has(n)) {
			matches++;
		}
	}
	if (matches) {
		const streak = streaks.find(x => x.remaining === matches)
		if (streak)
			streak.copies += copies;
		else
			streaks.push({ remaining: matches, copies });
	}
}).on('close', function () {
	console.log(sum);
});