#!/usr/bin/env php
<?php
declare(strict_types=1);

$handle = fopen("input.txt", "r");
$columns = strlen(fgets($handle)) - 1;
rewind($handle);
$lines = 0;
$map = "";
$rocks = [];
while (($line = fgets($handle)) != false) {
	for ($i = 0; $i < strlen($line); $i++) {
		if ($line[$i] == 'O'):
			$rocks[] = $lines * ($columns + 1) + $i;
		endif;
	}
	$lines++;
	$map .= $line;
}
fclose($handle);

const NORTH = 0;
const WEST = 1;
const SOUTH = 2;
const EAST = 3;

$seen = [];
$shortcutted = false;
for ($i = 0; $i < 1_000_000_000 * 4; $i++) {
	if (!$shortcutted && $i % 4 == 0) {
		$hash = hash("md5", $map);
		if (!empty($seen[$hash])) {
			$since = $i - $seen[$hash];
			$remaining = 1_000_000_000 * 4 - $i;
			$i = 1_000_000_000 * 4 - 1 - $remaining % $since;
			$shortcutted = true;
		}
		else {
			$seen[$hash] = $i;
		}
	}

	foreach ($rocks as $j => $rock) {
		[$offset, $min, $max] = match ($i % 4) {
			NORTH => [-$columns - 1, 0, $rock],
			WEST => [-1, ($columns + 1) * intdiv($rock, $columns + 1) - 1, $rock],
			SOUTH => [$columns + 1, $rock, $lines * ($columns + 1) - 1],
			EAST => [1, $rock, ($columns + 1) * (intdiv($rock, $columns + 1) + 1) - 1],
		};
		$target = $rock + $offset;
		while (
			$target > $min &&
			$target < $max &&
			$map[$target] != '#'
		) {
			if ($map[$target] == "\n") {
				echo "ERROR: $offset $min $max $target $rock" . PHP_EOL;
				exit;
			}
			$target += $offset;
		}
		do {
			$target -= $offset;
		} while (
			$target != $rock &&
			($map[$target] == '#' || $map[$target] == 'O')
		);
		if ($target != $rock) {
			$map[$rock] = '.';
			$map[$target] = 'O';
			$rocks[$j] = $target;
		}
	}
}

// echo $map . PHP_EOL;

$sum = 0;
foreach ($rocks as $rock) {
	$sum += $lines - intdiv($rock, $columns + 1);
}

echo $sum . PHP_EOL;
