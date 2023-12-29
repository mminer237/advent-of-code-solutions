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

function shoot_beam(int $row, int $column, Direction $direction, array &$energized_tiles = []): int {
	global $map;
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
					return count($energized_tiles);
				}
				if ($direction === Direction::Left || $direction === Direction::Right) {
					$direction = Direction::Up;
					shoot_beam($location[0], $location[1], Direction::Down, $energized_tiles);
				}
				break;
			case "-":
				if ($energized_tiles["$location[0],$location[1]"] ?? false) {
					return count($energized_tiles);
				}
				if ($direction === Direction::Up || $direction === Direction::Down) {
					$direction = Direction::Left;
					shoot_beam($location[0], $location[1], Direction::Right, $energized_tiles);
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
	return count($energized_tiles);
}

$max_energy = 0;
for ($row = 0; $row < count($map); $row++) {
	$max_energy = max($max_energy, shoot_beam($row, 0, Direction::Right));
	$max_energy = max($max_energy, shoot_beam($row, count($map[$row]), Direction::Left));
}
for ($column = 0; $column < count($map[0]); $column++) {
	$max_energy = max($max_energy, shoot_beam(0, $column, Direction::Down));
	$max_energy = max($max_energy, shoot_beam(count($map), $column, Direction::Up));
}

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

echo $max_energy . PHP_EOL;

?>
