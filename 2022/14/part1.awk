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
  return scan[pos["y"]][pos["x"]] # rock(1) or sand(2)
}

function resetSand(pos) {
  ++fallen_sand
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
}

function solve(_, sand_pos, target) {
  resetSand(sand_pos)

  while (sand_pos["y"] <= max_y) {
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
    for (j = min_x; j <= max_x; j++) {
      if (j == min_x || j == 500 || j == max_x) {
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
    for (phony_x = 0; phony_x <= max_x - min_x; phony_x++) {
      x = min_x + phony_x

      if (y == 0 && x == 500) {
        printf("+")
      } else {
        if (scan[y][x] == 1) {
          printf("#")
        } else if (scan[y][x] == 2) {
          printf("o")
        } else {
          printf(".")
        }
      }
    }
    printf("\n")
  }

  printf("\n")
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
  drawScan()

  solve()

  printf("Settled sand: %s\n", fallen_sand)
}
