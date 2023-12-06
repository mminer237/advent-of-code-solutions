#!/usr/bin/env hhvm

class MapRange {
	private int $offset;
	public function __construct(
		int $toStart,
		public int $fromStart,
		private int $length
	) {
		$this->offset = $toStart - $fromStart;
	}

	public function remainingInRange(int $n): int {
		return
			$n >= $this->fromStart &&
			$n <= $this->fromStart + $this->length ?
				$this->fromStart + $this->length - $n - 1 :
				0;
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

<<__EntryPoint>>
function main(): noreturn {
	$maps = dict[];
	$handle = fopen("input.txt", "r");
	while (($line = fgets($handle)) !== false) {
		$parts = explode(" ", rtrim($line));
		if (isset($parts[0]) && $parts[0] !== '') {
			if ($parts[0] === 'seeds:') {
				$seeds = array_map('intval', array_slice($parts, 1));
			}
			else if ($parts[1] === 'map:') {
				list($from, $_, $to) = explode('-', $parts[0]);
				$maps[$from] = dict[
					'to' => $to,
					'ranges' => vec[]
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

	foreach ($maps as $type => $_) {
		usort(inout $maps[$type]['ranges'], function($a, $b) {
			return $a->fromStart - $b->fromStart;
		});
	}

	$location = INF;
	for ($i = 0; $i < count($seeds); $i += 2) {
		for ($j = 0; $j < $seeds[$i + 1]; $j++) {
			$type = 'seed';
			$n = $seeds[$i] + $j;
			$smallest_remaining = INF;
			while ($type !== 'location') {
				$map = $maps[$type];
				$type = $map['to'];
				foreach ($map['ranges'] as $range) {
					$remaining = $range->remainingInRange($n);
					if ($remaining > 0) {
						$n = $range->convert($n);
						if ($remaining < $smallest_remaining) {
							$smallest_remaining = $remaining;
						}
						break;
					}
					else if ($range->fromStart > $n) {
						$missing_remaining = $range->fromStart - $n - 1;
						if ($missing_remaining < $smallest_remaining) {
							$smallest_remaining = $missing_remaining;
						}
					}
				}
			}
			$j += $smallest_remaining;
			if ($n < $location) {
				$location = $n;
			}
		}
	}

	echo $location."\n";
	exit(0);
}
