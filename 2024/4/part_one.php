<?php
const WORD = ['X', 'M', 'A', 'S'];
define('WORD_END', count(WORD) - 1);
const PREVIOUS_OFFSETS = [
	[-1, -1],
	[ 0, -1],
	[ 1, -1],
	[-1,  0]
];
$fp = fopen('input.txt', 'r');
if ($fp) {
	$count = 0;
	$map = [];
	$li = 0;
    while (($line = fgets($fp)) !== false) {
        for ($ci = 0; $ci < strlen($line); $ci++) {
			if (($wi = array_search($line[$ci], WORD)) !== false) {
				if ($wi === 0 || $wi === WORD_END) {
					$map[$ci][$li] = [[$wi, $wi, null]];
				}
				foreach (PREVIOUS_OFFSETS as $offset) {
					$px = $ci + $offset[0];
					$py = $li + $offset[1];
					if (isset($map[$px][$py])) {
						foreach ($map[$px][$py] as $pw) {
							if (
								(
									$pw[0] === 0 &&
									$pw[1] === $wi - 1 ||
									$pw[0] === WORD_END &&
									$pw[1] === $wi + 1
								) &&
								($pw[2] === null || $pw[2] === $offset)
							) {
								if (!isset($map[$ci][$li])) {
									$map[$ci][$li] = [];
								}
								$map[$ci][$li][] = [$pw[0], $wi, $offset];
								if (
									$pw[0] === 0 &&
									$wi === WORD_END ||
									$pw[0] === WORD_END &&
									$wi === 0
								) {
									$count++;
								}
							}
						}
					}
				}
			}
		}
		$li++;
    }
    fclose($fp);
	echo $count;
}
?>