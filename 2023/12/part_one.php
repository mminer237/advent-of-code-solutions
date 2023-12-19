#!/usr/bin/env php
<?php
$sum = 0;

$handle = fopen("input.txt", "r");
while (($line = fgets($handle)) !== false) {
	[$springs, $groups] = explode(" ", $line);
	$groups = array_map(
		"intval",
		explode(",", $groups)
	);
	test_line($springs, $groups);
}
fclose($handle);
echo $sum . "\n";

function test_line(string $springs, array $groups, int $run = 0): void {
	global $sum;
	for ($i = 0; $i < strlen($springs); $i++) {
		switch ($springs[$i]) {
			case ".":
				if ($run > 0) {
					if (isset($groups[0]) && $groups[0] == $run) {
						array_shift($groups);
						$run = 0;
					}
					else {
						return;
					}
				}
				break;
			case "#":
				if (!isset($groups[0])) {
					return;
				}
				$run++;
				break;
			case "?":
				test_line(
					"." . substr($springs, $i + 1),
					$groups,
					$run
				);
				test_line(
					"#" . substr($springs, $i + 1),
					$groups,
					$run
				);
				return;
				break;
			default:
				throw new Exception("Unknown spring type: " . $springs[$i]);
				break;
		}
		if (array_sum($groups) + count($groups) - 1 > strlen($springs) - $i + $run) {
			return;
		}
	}
	if (isset($groups[0]) && $groups[0] != $run) {
		return;
	}
	$sum++;
}

?>