#!/usr/bin/env php
<?php
declare(strict_types=1);
ini_set("memory_limit", "-1"); 

$map = [];

$handle = fopen("input.txt", "r");
$row = 0;
while (($line = fgets($handle)) !== false) {
	$map[$row++] = str_split(rtrim($line));
}
fclose($handle);

enum Direction: string {
	case Up = "U";
	case Right = "R";
	case Down = "D";
	case Left = "L";
}

class Path {
	public function __construct(
		public int $row,
		public int $column,
		public Direction $direction,
		public int $streak = 1,
		public int $score = 0,
	) {}
}

$paths = [new Path(0, 0, Direction::Right, 0)];
$score_cache = [];
$final_scores = [];

while (!empty($paths)) {
	$min = INF;
	foreach ($paths as $i => $path) {
		$location = "{$path->row},{$path->column}";
		if (isset($score_cache[$location])) {
			foreach ($score_cache[$location] as $score_record) {
				if ($score_record["direction"] === $path->direction) {
					if (
						$score_record["streak"] >= 4 &&
						$score_record["streak"] <= $path->streak &&
						$score_record["score"] <= $path->score &&
						$path->row + 4 < count($map) &&
						$path->column + 4 < count($map[0])
					) {
						unset($paths[$i]);
						continue 2;
					}
				}
				elseif ($score_record["direction"] === match ($path->direction) {
					Direction::Up => Direction::Down,
					Direction::Right => Direction::Left,
					Direction::Down => Direction::Up,
					Direction::Left => Direction::Right,
				}) {
					if (
						$score_record["streak"] >= 4 &&
						$path->streak >= 4 &&
						$score_record["score"] <= $path->score &&
						$path->row + 4 < count($map) &&
						$path->column + 4 < count($map[0])
					) {
						unset($paths[$i]);
						continue 2;
					}
				}
				elseif ($score_record["score"] + 20 <= $path->score) {
					// Kill it if it's an arbitrary amount worse
					unset($paths[$i]);
					continue 2;
				}
			}
		}
		if (!isset($score_cache[$location])) {
			$score_cache[$location] = [];
		}
		$score_cache[$location][] = [
			"direction" => $path->direction,
			"streak"    => $path->streak,
			"score"     => $path->score
		];

		foreach (Direction::cases() as $direction) {
			if ($direction === $path->direction) {
				if ($path->streak === 10) {
					continue;
				}
			}
			elseif ($path->streak < 4) {
				continue;
			}
			elseif ($direction === match ($path->direction) {
				Direction::Up => Direction::Down,
				Direction::Right => Direction::Left,
				Direction::Down => Direction::Up,
				Direction::Left => Direction::Right,
			})
				continue; // Can't go backwards
				
			$new_path = clone $path;
			$new_path->direction = $direction;
			if ($direction === $path->direction) {
				$new_path->streak = $path->streak + 1;
			}
			else {
				$new_path->streak = 1;
			}
			switch ($direction) {
				case Direction::Up:
					$new_path->row--;
					break;
				case Direction::Right:
					$new_path->column++;
					break;
				case Direction::Down:
					$new_path->row++;
					break;
				case Direction::Left:
					$new_path->column--;
					break;
			}
			if (
				$new_path->row < 0 ||
				$new_path->column < 0 ||
				$new_path->row >= count($map) ||
				$new_path->column >= count($map[0])
			) {
				// Out of bounds
				continue;
			}

			$new_path->score += $map[$new_path->row][$new_path->column];

			/* Trim really high scoring paths */
			if ($new_path->score > $min + 30) {
				continue;
			}
			elseif ($new_path->score < $min) {
				$min = $new_path->score;
			}
			$paths[] = $new_path;
		}
		unset($paths[$i]);

		if (
			$path->row === count($map) - 1 &&
			$path->column === count($map[0]) - 1 &&
			$path->streak >= 4
		) {
			$final_scores[] = $path->score;
		}
	}
}

echo min($final_scores) . PHP_EOL;

?>
