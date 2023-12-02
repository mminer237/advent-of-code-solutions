import std/rdstdin
import std/strutils
import std/tables
import tinyre

var input = readLineFromStdin("")
var limits: array[3, int]
var matches: array[4, string]
var match_count = match(input, re"(\d+)\D+(\d+)\D+(\d+)", matches)
if match_count > 3:
    for i, n in matches[1..3]:
        limits[i] = parseInt(n)
    echo "Looking for games with " & $limits[0] & " red, " & $limits[1] & " green, and " & $limits[2] & " blue stones or fewer..."
elif match_count > 0:
    echo "Not enough stone numbers entered"
else:
    echo "Stone numbers not entered"

var colors = {"red": 0, "green": 1, "blue": 2}.toTable
type InvalidGameError = object of ValueError

proc check_item(count: int, color: string): void =
    var color_index = colors[color]
    if limits[color_index] < count:
        raise newException(InvalidGameError, "Too many " & color & " stones (" & $count & " > " & $limits[color_index] & ")")

var sum = 0
for line in lines "input.txt":
    var game: int
    var buffer = ""
    var count: int
    try:
        for c in line:
            case c:
                of ':':
                    try:
                        game = parseInt(buffer)
                    except ValueError:
                        echo "Invalid game number" & buffer
                        quit(1)
                    buffer = ""
                of ' ':
                    try:
                        count = parseInt(buffer)
                    except ValueError:
                        discard
                    buffer = ""
                of ',', ';':
                    check_item(count, buffer)
                else:
                    buffer.add(c)
        # Handle last item
        check_item(count, buffer)
    except InvalidGameError:
        echo "❌ Game " & $game & " is invalid—" & getCurrentExceptionMsg()
        continue
    sum += game
    echo "✔️  Game " & $game & " is valid"
echo "----------"
echo "Total: " & $sum
