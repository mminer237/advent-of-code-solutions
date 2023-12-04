#!/usr/bin/env node

const fs = require('fs');
const readline = require('readline');

let sum = 0;
const lineReader = readline.createInterface({
	input: fs.createReadStream('input.txt')
});
lineReader.on('line', function (line) {
	line = line.split(/ +/);
	const pipe = line.indexOf('|');
	const winners = new Set(line.slice(2, pipe).map(Number));
	let score = 0;
	for (const n of line.slice(pipe + 1).map(Number)) {
		if (winners.has(n)) {
			if (!score)
				score = 1;
			else
				score *= 2;
		}
	}
	console.log(`Game ${line[1]} ${score} point${score !== 1 ? 's' : ''}`)
	sum += score;
}).on('close', function () {
	console.log('------------------');
	console.log(`Total: ${sum}`);
});