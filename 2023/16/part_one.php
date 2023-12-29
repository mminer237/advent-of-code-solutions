#!/usr/bin/env php
<?php
declare(strict_types=1);
ini_set('memory_limit', '20G');

$map = [];

$handle = fopen("input.txt", "r");
$row = 0;
while (($line = fgets($handle)) !== false) {
	$map[$row++] = str_split(rtrim($line));
}
fclose($handle);

enum Direction {
	case Up;
	case Right;
	case Down;
	case Left;
}

$energized_tiles = [];

function shoot_beam(int $row, int $column, Direction $direction): void {
	global $map, $energized_tiles;
	$location = [$row, $column];
	while (isset($map[$location[0]][$location[1]])) {
		switch ($map[$location[0]][$location[1]]) {
			case ".":
				break;
			case "/":
				$direction = match ($direction) {
					Direction::Up => Direction::Right,
					Direction::Right => Direction::Up,
					Direction::Down => Direction::Left,
					Direction::Left => Direction::Down,
				};
				break;
			case "\\":
				$direction = match ($direction) {
					Direction::Up => Direction::Left,
					Direction::Right => Direction::Down,
					Direction::Down => Direction::Right,
					Direction::Left => Direction::Up,
				};
				break;
			case "|":
				if ($energized_tiles["$location[0],$location[1]"] ?? false) {
					return;
				}
				if ($direction === Direction::Left || $direction === Direction::Right) {
					$direction = Direction::Up;
					shoot_beam($location[0], $location[1], Direction::Down);
				}
				break;
			case "-":
				if ($energized_tiles["$location[0],$location[1]"] ?? false) {
					return;
				}
				if ($direction === Direction::Up || $direction === Direction::Down) {
					$direction = Direction::Left;
					shoot_beam($location[0], $location[1], Direction::Right);
				}
				break;
			default:
				throw new Exception("Unknown tile type: " . $map[$location[0]][$location[1]]);
				break;
		}
		$energized_tiles["$location[0],$location[1]"] = true;
		switch ($direction) {
			case Direction::Up:
				$location[0]--;
				break;
			case Direction::Right:
				$location[1]++;
				break;
			case Direction::Down:
				$location[0]++;
				break;
			case Direction::Left:
				$location[1]--;
				break;
		}
	}
}
shoot_beam(0, 0, Direction::Right);

function print_map(): void {
	global $map, $energized_tiles;
	for ($row = 0; $row < count($map); $row++) {
		for ($column = 0; $column < count($map[$row]); $column++) {
			if (isset($energized_tiles["$row,$column"])) {
				echo "#";
			} else {
				echo ".";
			}
		}
		echo PHP_EOL;
	}
	echo PHP_EOL;
}

echo count($energized_tiles) . PHP_EOL;

?>
