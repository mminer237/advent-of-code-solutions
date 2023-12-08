#!/usr/bin/env pwsh

Set-Variable -Name "ranks" -Option Constant -Value @(
	[char]"A",
	[char]"K",
	[char]"Q",
	[char]"T",
	[char]"9",
	[char]"8",
	[char]"7",
	[char]"6",
	[char]"5",
	[char]"4",
	[char]"3",
	[char]"2",
	[char]"J"
)

function GetCardValue {
	param (
		$cards
	)
	
	$occurances = $cards | Group-Object -NoElement
	if ($occurances.length -gt 1) {
		$occurances = $occurances | Sort-Object -Descending {$_.Name -eq "J"}
		if ($occurances[0].Name -eq "J") {
			$jokers = $occurances[0].Count
			[array]$occurances = $occurances | Select-Object -Skip 1
		}
		else {
			$jokers = 0
		}
		$occurances = ($occurances | Sort-Object -Descending -Property Count)
		$occurances[0] = [PSCustomObject]@{
			Name = $occurances[0].Name
			Count = $occurances[0].Count + $jokers
		}
	}
	$score = $occurances[0].Count * 16000000
	if (
		($occurances[0].Count -eq 3 -or $occurances[0].Count -eq 2) -and
		$occurances[1].Count -eq 2
	) {
		$score += 8000000
	}
	for ($i = 0; $i -lt $cards.length; $i++) {
		$score += ($ranks.length - $ranks.indexOf($cards[$i]) - 1) *
			[Math]::Pow($ranks.length + 1, ($cards.length - $i))
	}
	$score
}

$rankedCards = Get-Content -Path 'input.txt' |
	% { ,@($_ -split " ") } |
	Sort-Object { GetCardValue($_[0].toCharArray()) }
$sum = 0
for ($i = 0; $i -lt $rankedCards.length; $i++) {
	$sum += [int]($rankedCards[$i][1]) * ($i + 1)
}
$sum
