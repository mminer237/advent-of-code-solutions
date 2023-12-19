#!/usr/bin/env hhvm

use namespace HH\Lib\Vec;

<<__EntryPoint>>
function main(): noreturn {
	$sum = 0;
	$seen = dict[];

	$handle = fopen("input.txt", "r");
	while (($line = fgets($handle)) !== false) {
		list($springs, $groups) = split(" ", $line);
		$groups = Vec\map(
			split(",", $groups),
			$x ==> (int)$x
		);
		$sum += test_line(
			inout $seen,
			join(Vec\fill(5, $springs), "?"),
			Vec\flatten(Vec\fill(5, $groups))
		);
	}
	fclose($handle);
	echo $sum . "\n";
	exit(0);
}

function test_line(inout dict<string, int> $seen, string $springs, vec<string> $groups, int $run = 0): int {
	$partially_seen = dict[];
	$sum = 0;
	for ($i = 0; $i < strlen($springs); $i++) {
		$id = substr($springs, $i). " " . join(",", $groups) . " $run";
		if (isset($seen[$id])) {
			return $seen[$id];
		}
		switch ($springs[$i]) {
			case ".":
				if ($run > 0) {
					if (isset($groups[0]) && $groups[0] == $run) {
						array_shift(inout $groups);
						$run = 0;
					}
					else {
						$seen[$id] = $sum;
						process_seen(inout $seen, $partially_seen, $sum);
						return $sum;
					}
				}
				break;
			case "#":
				if (!isset($groups[0])) {
					$seen[$id] = $sum;
					process_seen(inout $seen, $partially_seen, $sum);
					return $sum;
				}
				$run++;
				break;
			case "?":
				if (isset($groups[0])) {
					$sum += test_line(
						inout $seen,
						"#" . substr($springs, $i + 1),
						$groups,
						$run
					);
				}
				$sum += test_line(
					inout $seen,
					"." . substr($springs, $i + 1),
					$groups,
					$run
				);
				$seen[$id] = $sum;
				process_seen(inout $seen, $partially_seen, $sum);
				return $sum;
			default:
				throw new Exception("Unknown spring type: " . $springs[$i]);
		}
		if (array_sum($groups) + count($groups) - 1 > strlen($springs) - $i + $run) {
			$seen[$id] = $sum;
			process_seen(inout $seen, $partially_seen, $sum);
			return $sum;
		}
		$partially_seen[$id] = $sum;
	}
	if (!isset($groups[0]) || $groups[0] == $run) {
		$sum++;
	}
	process_seen(inout $seen, $partially_seen, $sum);
	return $sum;
}

function process_seen(inout dict<string, int> $seen, dict<string, int> $partially_seen, int $sum): void {
	foreach ($partially_seen as $id => $inverse_sum) {
		$seen[$id] = $sum - $inverse_sum;
	}
}
