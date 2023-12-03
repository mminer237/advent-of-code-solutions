<?php
$input = file_get_contents(__DIR__.'\input.txt');
$lines = explode("\n", $input);
class Gear {
	public $id;
	private $n1;
	private $n2;
	public function __construct(string $x, string $y) {
		$this->id = self::getId($x, $y);
	}
	static public function getId(string $x, string $y) {
		return "$x,$y";
	}
	public function addNumber(int $n) {
		if (!isset($this->n1)) {
			$this->n1 = $n;
		}
		else if (!isset($this->n2)) {
			$this->n2 = $n;
			echo "Found ".$this->n1."*$n\n";
		}
		else {
			throw new Exception("Gear already has two numbers");
		}
	}
	public function getValue() {
		return $this->n1 * $this->n2;
	}
}
$gears = [];
$sum = 0;
function reportGear(int $x, int $y, string $n) {
	global $gears;
	$gearId = Gear::getId($x, $y);
	if (!isset($gears[$gearId])) {
		$gears[$gearId] = new Gear($x, $y);
	}
	$gears[$gearId]->addNumber(intval($n));
}
for ($i = 0; $i < count($lines); $i++) {
	preg_match_all('/\d+/', $lines[$i], $matches, PREG_OFFSET_CAPTURE);
	foreach ($matches[0] as $match) {
		if ($match[1] > 0) {
			if ($lines[$i][$match[1] - 1] === '*') {
				reportGear($match[1] - 1, $i, $match[0]);
				continue;
			}
		}
		if ($match[1] + strlen($match[0]) < strlen($lines[$i])) {
			if ($lines[$i][$match[1] + strlen($match[0])] === '*') {
				reportGear($match[1] + strlen($match[0]), $i, $match[0]);
				continue;
			}
		}
		if ($i > 0) {
			for ($j = max(0, $match[1] - 1); $j <= min(strlen($lines[$i - 1]) - 1, $match[1] + strlen($match[0])); $j++) {
				if ($lines[$i - 1][$j] === '*') {
					reportGear($j, $i - 1, $match[0]);
					continue 2;
				}
			}
		}
		if ($i < count($lines) - 1) {
			for ($j = max(0, $match[1] - 1); $j <= min(strlen($lines[$i + 1]) - 1, $match[1] + strlen($match[0])); $j++) {
				if ($lines[$i + 1][$j] === '*') {
					reportGear($j, $i + 1, $match[0]);
					continue 2;
				}
			}
		}
	}
}
foreach ($gears as $gear) {
	$sum += $gear->getValue();
}
echo $sum;
?>