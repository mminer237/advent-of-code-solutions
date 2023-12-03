<?php
$input = file_get_contents(__DIR__.'\input.txt');
$lines = explode("\n", $input);
define('SYMBOLS', ['+', '-', '*', '/', '%', '&', '@', '=', '$', '#']);
$sum = 0;
for ($i = 0; $i < count($lines); $i++) {
	preg_match_all('/\d+/', $lines[$i], $matches, PREG_OFFSET_CAPTURE);
	foreach ($matches[0] as $match) {
		if ($match[1] > 0) {
			if (in_array($lines[$i][$match[1] - 1], SYMBOLS)) {
				echo "← Found $match[0] at line $i\n";
				$sum += intval($match[0]);
				continue;
			}
		}
		if ($match[1] + strlen($match[0]) < strlen($lines[$i])) {
			if (in_array($lines[$i][$match[1] + strlen($match[0])], SYMBOLS)) {
				echo "→ Found $match[0] at line $i\n";
				$sum += intval($match[0]);
				continue;
			}
		}
		if ($i > 0) {
			for ($j = max(0, $match[1] - 1); $j <= $match[1] + strlen($match[0]); $j++) {
				if (in_array($lines[$i - 1][$j], SYMBOLS)) {
					echo "↑ Found $match[0] at line $i\n";
					$sum += intval($match[0]);
					continue 2;
				}
			}
		}
		if ($i < count($lines) - 1) {
			for ($j = max(0, $match[1] - 1); $j <= min(strlen($lines[$i + 1]), $match[1] + strlen($match[0])); $j++) {
				if (in_array($lines[$i + 1][$j], SYMBOLS)) {
					echo "↓ Found $match[0] at line $i\n";
					$sum += intval($match[0]);
					continue 2;
				}
			}
		}
	}
}
echo $sum;
?>