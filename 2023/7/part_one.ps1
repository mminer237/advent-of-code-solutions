#!/usr/bin/env pwsh

Set-Variable -Name "ranks" -Option Constant -Value @(
	[char]"A",
	[char]"K",
	[char]"Q",
	[char]"J",
	[char]"T",
	[char]"9",
	[char]"8",
	[char]"7",
	[char]"6",
	[char]"5",
	[char]"4",
	[char]"3",
	[char]"2"
)

function GetCardValue {
	param (
		$cards
	)
	
	$occurances = (@($cards | Sort-Object -Unique | % {
		$card = $_;
		,@($card, ($cards | Where-Object { $_ -eq $card }).count)
	}))
	$occurances = $occurances.length -gt 1 ? ($occurances  | Sort-Object -Descending {$_[1]}) : $occurances
	$score = $occurances[0][1] * 16000000
	if (
		($occurances[0][1] -eq 3 -or $occurances[0][1] -eq 2) -and
		$occurances[1][1] -eq 2
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
