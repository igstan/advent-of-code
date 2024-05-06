#!/usr/bin/env gawk -f

@include "prelude"

function fillSensor(board, point, radius, _, x, y, span, target_x, target_y) {
  for (y = -radius; y <= radius; y++) {
    span = radius - abs(y)
    for (x = -span; x <= span; x++) {
      target_x = point["x"] + x
      target_y = point["y"] + y

      min_x = min(min_x, target_x)
      max_x = max(max_x, target_x)

      min_y = min(min_y, target_y)
      max_y = max(max_y, target_y)

      if (x == 0 && y == 0) {
        board[target_y][target_x] = "S"
      }

      if (board[target_y][target_x] != "") {
        continue
      }

      board[target_y][target_x] = "#"
    }
  }
}

function printScan(board, _, x, y) {
  # min_x = 0
  # max_x = 20
  # min_y = 0
  # max_y = 20

  for (y = min_y; y <= max_y; y++) {
    printf("%04s ", y)

    for (x = min_x; x <= max_x; x++) {
      if (board[y][x]) {
        printf("%s", board[y][x])
      } else {
        printf(".")
      }
    }

    printf("\n")
  }

  printf("\n")
}

BEGIN {
  target_y = 2000000
  # target_y = 10
}

{
  match($0, /Sensor at x=([-0-9]+), y=([-0-9]+): closest beacon is at x=([-0-9]+), y=([-0-9]+)/, groups)

  reading++
  point(sensors[reading], groups[1], groups[2])
  point(beacons[reading], groups[3], groups[4])
  radius = manhattan(sensors[reading], beacons[reading])

  board[groups[2]][groups[1]] = "S"
  board[groups[4]][groups[3]] = "B"

  if (NR == 1) {
    min_x = min(groups[1], groups[3])
    max_x = max(groups[1], groups[3])
    min_y = min(groups[2], groups[4])
    max_y = max(groups[2], groups[4])
    max_radius = radius
  } else {
    min_x = min(min(min_x, groups[1]), groups[3])
    max_x = max(max(max_x, groups[1]), groups[3])
    min_y = min(min(min_y, groups[2]), groups[4])
    max_y = max(max(max_y, groups[2]), groups[4])
    max_radius = max(max_radius, radius)
  }
}

END {
  printScan(board)

  for (reading in sensors) {
    sensor_radius = manhattan(sensors[reading], beacons[reading])
    fillSensor(board, sensors[reading], sensor_radius)
    printScan(board)
  }

  # printScan(board)

  # for (y = target_y - max_radius; y < target_y + max_radius; y++) {

  # }

  # for (x = min_x; x <= max_x; x++) {
  #   if (board[target_y][x] != "" && board[target_y][x] != "B") {
  #     total++
  #   }
  # }

  # printf("Total: %s\n", total)
}
