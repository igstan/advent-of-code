#!/usr/bin/env gawk -f

@include "prelude"

function markPoints(scan, fromPoint, uptoPoint) {
  x_ends[1] = fromPoint["x"]
  x_ends[2] = uptoPoint["x"]
  y_ends[1] = fromPoint["y"]
  y_ends[2] = uptoPoint["y"]

  asort(x_ends)
  asort(y_ends)

  for (y = y_ends[1]; y <= y_ends[2]; y++) {
    for (x = x_ends[1]; x <= x_ends[2]; x++) {
      scan[y][x] = 1
    }
  }
}

function readBelow(from, to) {
  to["x"] = from["x"]
  to["y"] = from["y"] + 1
}

function readDiagonalL(from, to) {
  to["x"] = from["x"] - 1
  to["y"] = from["y"] + 1
}

function readDiagonalR(from, to) {
  to["x"] = from["x"] + 1
  to["y"] = from["y"] + 1
}

function isRock(pos) {
  return scan[pos["y"]][pos["x"]] || # rock(1) or sand(2)
    pos["y"] == max_y                # enforced floor
}

function resetSand(pos) {
  fallen_sand++
  scan[pos["y"]][pos["x"]] = 2

  pos["x"] = 500
  pos["y"] = 0

  # drawScan()
}

function moveTo(sand_pos, target) {
  scan[sand_pos["y"]][sand_pos["x"]] = 0
  sand_pos["x"] = target["x"]
  sand_pos["y"] = target["y"]
  scan[sand_pos["y"]][sand_pos["x"]] = 2
  min_x = min(min_x, sand_pos["x"])
  max_x = max(max_x, sand_pos["x"])
  max_y = max(max_y, sand_pos["y"])
}

function solve(_, sand_pos, target, full) {
  resetSand(sand_pos)

  while (!full) {
    readBelow(sand_pos, target)

    if (!isRock(target)) {
      moveTo(sand_pos, target)
    } else {
      readDiagonalL(sand_pos, target)

      if (!isRock(target)) {
        moveTo(sand_pos, target)
      } else {
        readDiagonalR(sand_pos, target)

        if (!isRock(target)) {
          moveTo(sand_pos, target)
        } else {
          if (sand_pos["x"] == 500 && sand_pos["y"] == 0) {
            full = 1
          }

          resetSand(sand_pos)
        }
      }
    }
  }

  # last sand fell all the way through
  fallen_sand--
}

function drawScan() {
  for (i = 1; i <= countDigits(min_x); i++) {
    printf("%04s", "")
    for (j = min_x - 1; j <= max_x + 1; j++) {
      if (j == min_x - 1 || j == 500 || j == max_x + 1) {
        split(j, digits, //)
        printf("%d", digits[i])
      } else {
        printf(" ")
      }
    }
    printf("\n")
  }

  for (y = 0; y <= max_y; y++) {
    printf("%03s ", y)
    for (phony_x = 0; phony_x <= max_x - min_x + 2; phony_x++) {
      x = min_x + phony_x - 1

      if (y == 0 && x == 500) {
        printf("+")
      } else {
        if (scan[y][x] == 1 || y == max_y) {
          printf("█")
        } else if (scan[y][x] == 2) {
          printf("~")
        } else {
          printf(" ")
        }
      }
    }
    printf("\n")
  }

  printf("\n")
}

function addFloor() {
  max_y += 2
}

{
  delete paths

  n = split($0, points, / *-> */)

  for (i = 1; i <= n; i++) {
    m = split(points[i], coords, /,/)
    paths[i]["x"] = coords[1]
    paths[i]["y"] = coords[2]

    min_x = min_x == "" ? coords[1] : min(min_x, coords[1])
    max_x = max_x == "" ? coords[1] : max(max_x, coords[1])
    max_y = max_y == "" ? coords[2] : max(max_y, coords[2])

    if (i > 1) {
      # we have previous endpoint, the path's start endpoint
      markPoints(scan, paths[i - 1], paths[i])
    }
  }
}

END {
  addFloor()
  drawScan()
  solve()
  drawScan()

  printf("Settled sand: %s\n", fallen_sand)
}
