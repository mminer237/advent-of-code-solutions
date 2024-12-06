import std/strutils
import regex

var sum = 0
let r = re2(r"mul\((\d+),(\d+)\)")
for line in lines "input.txt":
    for match in findAll(line, r):
        sum += parseInt(line[match.group(0)]) * parseInt(line[match.group(1)])
echo sum

