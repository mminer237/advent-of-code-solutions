import std/strutils
import regex

var sum = 0
let do_regex = re2(r"(?<=\A|do\(\))(.+?)(?=\z|don't\(\))", {regexDotAll})
let mul_regex = re2(r"mul\((\d+),(\d+)\)")
let input = readFile("input.txt")
for do_match in findAll(input, do_regex):
    let do_block = input[do_match.group(0)]
    for mul_match in findAll(do_block, mul_regex):
        sum += parseInt(do_block[mul_match.group(0)]) * parseInt(do_block[mul_match.group(1)])
echo sum

