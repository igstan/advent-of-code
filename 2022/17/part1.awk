#!/usr/bin/env gawk -f

@include "prelude"

function readShapes(_, line, lineCount) {
  ROCK_COUNT = 1

  while ((getline line < "shapes") > 0) {
    if (line !~ /^$/) {
      split(line, ROCKS[ROCK_COUNT][++lineCount], //)
    } else {
      ROCK_COUNT++
      lineCount = 0
    }
  }

  close("shapes")
}

function nextBlow() {
  BLOW_I = (BLOW_I % BLOW_COUNT) + 1
  return BLOWS[BLOW_I]
}

function nextRock() {
  ROCK_I = (ROCK_I % ROCK_COUNT) + 1
  return ROCK_I
}

function canMove(rockIndex, tentativePos, _, hrock, wrock, x, y, gridX, gridY) {
  hrock = length(ROCKS[rockIndex])
  wrock = length(ROCKS[rockIndex][1])

  for (y = 1; y <= hrock; y++) {
    for (x = 1; x <= wrock; x++) {
      if (ROCKS[rockIndex][y][x] != "#") continue

      gridX = tentativePos["x"] + x - 1
      gridY = tentativePos["y"] + (hrock - y)

      if (OCCUPIED[gridY][gridX] == "#") {
        return 0
      }

      if (gridX < 1 || gridX > CHAMBER_WIDTH) {
        return 0
      }
    }
  }

  return 1
}

function mark(rockIndex, pos, _, hrock, wrock, x, y, gridX, gridY) {
  hrock = length(ROCKS[rockIndex])
  wrock = length(ROCKS[rockIndex][1])

  for (y = 1; y <= hrock; y++) {
    for (x = 1; x <= wrock; x++) {
      if (ROCKS[rockIndex][y][x] == "#") {
        gridX = pos["x"] + x - 1
        gridY = pos["y"] + (hrock - y)
        OCCUPIED[gridY][gridX] = "#"
      }
    }
  }

  # showOccupied()
}

function rockHeight(rockIndex, _) {
  return length(ROCKS[rockIndex])
}

function showOccupied(_, x, y) {
  for (y = MAX_HEIGHT; y >= 1; y--) {
    for (x = 1; x <= CHAMBER_WIDTH; x++) {
      if (OCCUPIED[y][x] == "#") {
        printf "%s", OCCUPIED[y][x]
      } else {
        printf "."
      }
    }
    printf "\n"
  }
  printf "------------------------\n"
}

{
  BLOW_COUNT = split($0, BLOWS, //)
}

END {
  CHAMBER_WIDTH = 7
  readShapes()

  # Fill in the floor.
  for (i = 1; i <= CHAMBER_WIDTH; i++) {
    OCCUPIED[1][i] = "#"
  }

  MAX_HEIGHT = 1 # At the start, this is effectively the chamber's floor.

  # Pretend there was a previous rock that's stopped now, so that
  # we summon a new one during the first iteration.
  rockStopped = 1
  action = "fall"

  while (fallenRocks < 2022) {
    if (action == "fall") {
      if (rockStopped) {
        rockStopped = 0
        currentRock = nextRock()
        rockPos["y"] = MAX_HEIGHT + 4
        rockPos["x"] = 3
        action = "blow"
      } else {
        # Attempt to move current rock
        tentativePos["x"] = rockPos["x"]
        tentativePos["y"] = rockPos["y"] - 1

        if (canMove(currentRock, tentativePos)) {
          rockPos["x"] = tentativePos["x"]
          rockPos["y"] = tentativePos["y"]
          action = "blow"
        } else {
          rockStopped = 1
          fallenRocks++
          MAX_HEIGHT = max(MAX_HEIGHT, rockPos["y"] + rockHeight(currentRock) - 1)
          mark(currentRock, rockPos)
          action = "fall"
        }
      }
    } else {
      blow = nextBlow()

      if (blow == ">") {
        tentativePos["x"] = min(CHAMBER_WIDTH, rockPos["x"] + 1)
      }

      if (blow == "<") {
        tentativePos["x"] = max(1, rockPos["x"] - 1)
      }

      if (!("x" in tentativePos)) {
        printf "bug: missing key `x` in `tentativePos`.\n"
        exit 1
      }

      tentativePos["y"] = rockPos["y"]

      if (canMove(currentRock, tentativePos)) {
        rockPos["x"] = tentativePos["x"]
        rockPos["y"] = tentativePos["y"]
      } else {
        # it must have hit a wall or a rock, so we do nothing
      }

      action = "fall"
    }
  }

  printf "fallenRocks: %s\n", fallenRocks
  printf "MAX_HEIGHT: %s\n", MAX_HEIGHT - 1 # minus floor
}
