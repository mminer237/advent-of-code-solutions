#!/usr/bin/env php
<?php
class MapRange {
	private int $offset;
	public function __construct(
		int $toStart,
		private int $fromStart,
		private int $length
	) {
		$this->offset = $toStart - $fromStart;
	}

	public function inRange(int $n): bool {
		return
			$n >= $this->fromStart &&
			$n <= $this->fromStart + $this->length;
	}

	public function convert(int $n): int {
		if (
			$n >= $this->fromStart &&
			$n <= $this->fromStart + $this->length
		) {
			return $n + $this->offset;
		}
		else {
			throw new Exception("Out of range");
		}
	}
}

$maps = [];
$handle = fopen("input.txt", "r");
while (($line = fgets($handle)) !== false) {
	$parts = explode(" ", rtrim($line));
	if (!empty($parts[0])) {
		if ($parts[0] === 'seeds:') {
			$seeds = array_map('intval', array_slice($parts, 1));
		}
		else if ($parts[1] === 'map:') {
			[$from, $_, $to] = explode('-', $parts[0]);
			$maps[$from] = [
				'to' => $to,
				'ranges' => []
			];
		}
		else {
			$maps[$from]['ranges'][] = new MapRange(
				...array_map('intval', $parts)
			);
		}
	}
}
fclose($handle);

$locations = [];
foreach ($seeds as $n) {
	$type = 'seed';
	while ($type !== 'location') {
		echo "$type $n → ";
		$map = $maps[$type];
		$type = $map['to'];
		foreach ($map['ranges'] as $range) {
			if ($range->inRange($n)) {
				$n = $range->convert($n);
				break;
			}
		}
		echo "$type $n\n";
	}
	$locations[] = $n;
	echo "\n";
}

echo min($locations);

?>