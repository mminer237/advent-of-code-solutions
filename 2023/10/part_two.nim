import std/bitops
import std/math
import std/sequtils
import std/sets

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

proc getOffset(direction: uint8): tuple[x: int, y: int] =
    return (
        int(bitsliced(direction, xSlice)) - 1,
        int(bitand(direction, yAxisMask)) - 1
    )

proc invertDirection(direction: uint8): uint8 =
    return (if bitsliced(direction, 2..2) == 1: bitxor(direction, 0b0010) else: bitxor(direction, 0b1000))

proc turnRight(direction: uint8): uint8 =
    return case direction:
        of north: east
        of east: south
        of south: west
        of west: north
        else: raise newException(ValueError, "Invalid direction")

# Look at a tile and figure out which direction to go next
var checkedTiles: HashSet[(int, int)]
var countedTiles: HashSet[(int, int)]
checkedTiles.incl(animal)
proc checkTile(x: int, y: int, fromDirection: uint8): uint8 =
    if x < 0 or y < 0 or y >= map.len or x >= map[y].len:
        return 0
    checkedTiles.incl((x, y))

    if animal.x == x and animal.y == y:
        echo "Found the animal again!"
        return 255

    let toDirection =
        if bitsliced(newTile(map[y][x]), firstEndSlice) == fromDirection:
            bitsliced(newTile(map[y][x]), secondEndSlice)
        elif bitsliced(newTile(map[y][x]), secondEndSlice) == fromDirection:
            bitsliced(newTile(map[y][x]), firstEndSlice)
        else:
            echo "Invalid direction"
            0

    # echo "Checking tile ", x, ", ", y, " (", map[y][x], ") from ",
    #     case fromDirection:
    #         of north: "north"
    #         of east: "east"
    #         of south: "south"
    #         of west: "west"
    #         else: "unknown"
    return toDirection

# Check all the starting directions
let starts = [
    (0, -1, south),
    (1, 0, west),
    (0, 1, north),
    (-1, 0, east)
]

# Begin paths of theoretical animals
for (initialX, initialY, initialFromDirection) in starts:
    var x = animal.x + initialX
    var y = animal.y + initialY
    var fromDirection = initialFromDirection
    var toDirection = invertDirection(fromDirection)
    var turnDifferential = 0
    while toDirection != 0:
        let newDirection = checkTile(x, y, fromDirection)
        if newDirection == toDirection:
            discard
        elif newDirection == turnRight(toDirection):
            turnDifferential += 1
        else:
            turnDifferential -= 1
        toDirection = newDirection
        if toDirection == 255:
            # Solve the puzzle here
            echo "Loop turned ", if turnDifferential < 0: "left" else: "right"
            
            var verticality = 0
            for y, _ in map:
                for x, c in map[y]:
                    if checkedTiles.contains((x, y)):
                        case c:
                            of '|':
                                verticality += 2
                            of 'F', 'J':
                                verticality += 1
                            of 'L', '7':
                                verticality -= 1
                            of 'S':
                                if initialFromDirection == north or
                                   initialFromDirection == south:
                                    verticality += 2
                                else:
                                    discard
                            else:
                                discard
                        verticality = verticality mod 4
                    elif abs(verticality) == 2:
                        countedTiles.incl((x, y))
            
            echo countedTiles.len
            for y, _ in map:
                for x, c in map[y]:
                    if (x, y) in countedTiles:
                        stdout.write "I"
                    elif (x, y) in checkedTiles:
                        stdout.write "X"
                    else:
                        stdout.write "."
                echo ""
            quit(0)

        let offset = getOffset(toDirection)
        (x, y) = (x + offset.x, y + offset.y)
        fromDirection = invertDirection(toDirection)
