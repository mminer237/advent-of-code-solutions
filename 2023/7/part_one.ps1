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
	}) | Sort-Object -Descending {$_[1]})
	$score = (13 - $ranks.indexOf($occurances[0][0])) * $occurances[0][1] * $occurances[0][1]
	if ($occurances[0][1] -eq 3 -and $occurances[1][1] -eq 2) {
		$score += (13 - $ranks.indexOf($occurances[1][0])) * $occurances[1][1]
	}
	// TODO: Handle ties
	$score
}

Get-Content -Path 'input.txt' |
	% { ,@($_ -split " ") } |
#	Sort-Object { GetCardValue($_[0].toCharArray()) }
	Sort-Object { GetCardValue($_[0].toCharArray()) } |
	% { "$_  $(GetCardValue($_[0].toCharArray()))" }

