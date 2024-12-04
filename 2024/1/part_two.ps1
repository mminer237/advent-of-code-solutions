#!/usr/bin/env pwsh

$sum = 0
$lists = @(@(), @{})
Get-Content -Path 'input.txt' |
	% {
		$x = $_ -split "   "
		$lists[0] += $x[0]
		if ($lists[1].ContainsKey($x[1])) {
			$lists[1][$x[1]]++
		}
		else {
			$lists[1][$x[1]] = 1
		}
	}
$lists[0] | % {
	if ($lists[1].ContainsKey($_)) {
		$sum += [int]$_ * $lists[1][$_]
	}
}
$sum
