import std/bitops
import std/math
import std/sequtils

let f = open("input.txt")
var line: string
var map: seq[seq[char]]
while readLine(f, line):
    map.add(toSeq(line.items))
f.close()

const north: uint8 = 0b0100
const east: uint8 = 0b1001
const south: uint8 = 0b0110
const west: uint8 = 0b0001
const xSlice = 2 .. 3
const yAxisMask: uint8 = 0b0011
const firstEndSlice = 0 .. 3
const secondEndSlice = 4 .. 7
const secondEndRotation = 4
type Tile = uint8

proc newTile(tile: char): Tile =
    return Tile(
        case tile:
            of '|':
                bitor(north, rotateLeftBits(south, secondEndRotation))
            of '-':
                bitor(west, rotateLeftBits(east, secondEndRotation))
            of 'L':
                bitor(north, rotateLeftBits(east, secondEndRotation))
            of 'F':
                bitor(south, rotateLeftBits(east, secondEndRotation))
            of '7':
                bitor(south, rotateLeftBits(west, secondEndRotation))
            of 'J':
                bitor(north, rotateLeftBits(west, secondEndRotation))
            else:
                raise newException(ValueError, "Invalid tile")
    )

var animal: tuple[x: int, y: int]
# Find the animal
for y, _ in map:
    for x, c in map[y]:
        if c == 'S':
            echo "Animal found at ", x, ", ", y
            animal = (x, y)
            break

# Look at a tile and figure out which direction to go next
proc checkTile(x: int, y: int, fromDirection: uint8, tilesVisited: int): uint8 =
    if x < 0 or y < 0 or y >= map.len or x >= map[y].len:
        return 0
    if animal.x == x and animal.y == y:
        echo "Found the animal again!"
        echo "The farthest distance was: ", int(ceil((tilesVisited + 1) / 2))
        quit(0)
    else:
        # echo "Checking tile ", x, ", ", y, " (", map[y][x], ") from ", 
        #     case fromDirection:
        #         of north: "north"
        #         of east: "east"
        #         of south: "south"
        #         of west: "west"
        #         else: "unknown"
        return
            if bitsliced(newTile(map[y][x]), firstEndSlice) == fromDirection:
                bitsliced(newTile(map[y][x]), secondEndSlice)
            elif bitsliced(newTile(map[y][x]), secondEndSlice) == fromDirection:
                bitsliced(newTile(map[y][x]), firstEndSlice)
            else:
                echo "Invalid direction"
                0

# Check all the starting directions
let starts = [
    (0, -1, south),
    (1, 0, west),
    (0, 1, north),
    (-1, 0, east)
]

proc invertDirection(direction: uint8): uint8 =
    return (if bitsliced(direction, 2..2) == 1: bitxor(direction, 0b0010) else: bitxor(direction, 0b1000))

# Begin paths of theoretical animals
for (x, y, fromDirection) in starts:
    var x = animal.x + x
    var y = animal.y + y
    var fromDirection = fromDirection
    var toDirection = invertDirection(fromDirection)
    var tilesVisited = 0
    while toDirection != 0:
        toDirection = checkTile(x, y, fromDirection, tilesVisited)
        x = x + int(bitsliced(toDirection, xSlice)) - 1
        y = y + int(bitand(toDirection, yAxisMask)) - 1
        fromDirection = invertDirection(toDirection)
        tilesVisited += 1
