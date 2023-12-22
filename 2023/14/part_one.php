#!/usr/bin/env php
<?php
declare(strict_types=1);

$sum = 0;
$handle = fopen("input.txt", "r");
$columns = array_fill(0, strlen(fgets($handle)) - 1, 0);
rewind($handle);
$lines = 0;
$rocks = 0;
while (($line = fgets($handle)) != false) {
	$lines++;
	for ($i = 0; $i < strlen($line); $i++) {
		switch ($line[$i]) {
			case 'O':
				$sum += $columns[$i]++;
				$rocks++;
				break;
			case '#':
				$columns[$i] = $lines;
				break;
		}
	}
}
fclose($handle);

$sum = $rocks * $lines - $sum;

echo $sum . PHP_EOL;
