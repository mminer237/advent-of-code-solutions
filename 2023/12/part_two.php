#!/usr/bin/env php
<?php
declare(strict_types=1);
ini_set("memory_limit", "-1"); 
$sum = 0;
$problems = 0;
$seen = [];
$handle = fopen("input.txt", "r");
while (($line = fgets($handle)) !== false) {
	[$springs, $groups] = explode(" ", $line);
	$groups = array_map(
		"intval",
		explode(",", $groups)
	);
	$sum += test_line(
		implode("?", array_fill(0, 5, $springs)),
		array_merge(...array_fill(0, 5, $groups))
	);
}
fclose($handle);
echo $sum . "\n";

function test_line(string $springs, array $groups, int $run = 0): int {
	global $seen;
	$partially_seen = [];
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
						array_shift($groups);
						$run = 0;
					}
					else {
						$seen[$id] = $sum;
						process_seen($partially_seen, $sum);
						return $sum;
					}
				}
				break;
			case "#":
				if (!isset($groups[0])) {
					$seen[$id] = $sum;
					process_seen($partially_seen, $sum);
					return $sum;
				}
				$run++;
				break;
			case "?":
				if (isset($groups[0])) {
					$sum += test_line(
						"#" . substr($springs, $i + 1),
						$groups,
						$run
					);
				}
				$sum += test_line(
					"." . substr($springs, $i + 1),
					$groups,
					$run
				);
				$seen[$id] = $sum;
				process_seen($partially_seen, $sum);
				return $sum;
			default:
				throw new Exception("Unknown spring type: " . $springs[$i]);
		}
		if (array_sum($groups) + count($groups) - 1 > strlen($springs) - $i + $run) {
			$seen[$id] = $sum;
			process_seen($partially_seen, $sum);
			return $sum;
		}
		$partially_seen[$id] = $sum;
	}
	if (!isset($groups[0]) || $groups[0] == $run) {
		$sum++;
	}
	process_seen($partially_seen, $sum);
	return $sum;
}

function process_seen(array &$partially_seen, int $sum): void {
	global $seen;
	foreach ($partially_seen as $id => $inverse_sum) {
		$seen[$id] = $sum - $inverse_sum;
	}
}

?>