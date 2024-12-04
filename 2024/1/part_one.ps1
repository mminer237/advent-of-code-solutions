#!/usr/bin/env pwsh

$sum = 0
$lists = @(@(), @())
Get-Content -Path 'input.txt' |
	% {
		$x = $_ -split "   "
		$lists[0] += $x[0]
		$lists[1] += $x[1]
	}
$lists = ($lists | % { ,@( $_ | Sort-Object ) });
for ($i = 0; $i -lt $lists[0].Length; $i++) {
	$sum += [Math]::Abs($lists[0][$i] - $lists[1][$i])
}
$sum
