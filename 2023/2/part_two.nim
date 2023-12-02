import std/strutils
import std/tables

var colors = {"red": 0, "green": 1, "blue": 2}.toTable

var sum = 0
for line in lines "input.txt":
    var buffer = ""
    var count: int
    var maxes = [0, 0, 0]
    for c in line:
        case c:
            of ':':
                buffer = ""
            of ' ':
                try:
                    count = parseInt(buffer)
                except ValueError:
                    discard
                buffer = ""
            of ',', ';':
                if maxes[colors[buffer]] < count:
                    maxes[colors[buffer]] = count
            else:
                buffer.add(c)
    # Handle last item
    if maxes[colors[buffer]] < count:
        maxes[colors[buffer]] = count
    var cube = maxes[0] * maxes[1] * maxes[2]
    sum += cube
    echo $maxes[0] & "×" & $maxes[1] & "×" & $maxes[2] & " = " & $cube
echo "----------"
echo "Total: " & $sum
