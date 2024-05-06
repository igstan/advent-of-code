#!/usr/bin/env gawk -f

@include "array"
@include "prelude"

function propose(grid, proposal, options, _, a, b, c, len, mid_x, mid_y) {
  a = grid[options[1]["y"]][options[1]["x"]]["spot"] != 1
  b = grid[options[2]["y"]][options[2]["x"]]["spot"] != 1
  c = grid[options[3]["y"]][options[3]["x"]]["spot"] != 1

  if (a && b && c) {
    mid_x = options[2]["x"]
    mid_y = options[2]["y"]
    len = ++proposal[mid_y][mid_x]["spot"]
    proposal[mid_y][mid_x]["from"][len]["x"] = options[0]["x"]
    proposal[mid_y][mid_x]["from"][len]["y"] = options[0]["y"]
    return 1
  }

  return 0
}

function points(direction, result, x, y, _) {
  if (direction == "N") {
    point(result[0], x    , y    )
    point(result[1], x - 1, y - 1)
    point(result[2], x    , y - 1)
    point(result[3], x + 1, y - 1)
  }

  if (direction == "S") {
    point(result[0], x    , y    )
    point(result[1], x - 1, y + 1)
    point(result[2], x    , y + 1)
    point(result[3], x + 1, y + 1)
  }

  if (direction == "W") {
    point(result[0], x    , y    )
    point(result[1], x - 1, y - 1)
    point(result[2], x - 1, y    )
    point(result[3], x - 1, y + 1)
  }

  if (direction == "E") {
    point(result[0], x    , y    )
    point(result[1], x + 1, y - 1)
    point(result[2], x + 1, y    )
    point(result[3], x + 1, y + 1)
  }
}

function trackBoundaries(mins, maxs, x, y) {
  x = int(x)
  y = int(y)
  mins["x"] = "x" in mins ? min(mins["x"], x) : x
  mins["y"] = "y" in mins ? min(mins["y"], y) : y
  maxs["x"] = "x" in maxs ? max(maxs["x"], x) : x
  maxs["y"] = "y" in maxs ? max(maxs["y"], y) : y
}

function noNeighbors(grid, x, y, _, i, j) {
  for (i = -1; i <= 1; i++) {
    for (j = -1; j <= 1; j++) {
      if (i == 0 && j == 0) continue
      if (grid[y + i][x + j]["spot"]) return 0
    }
  }

  return 1
}

function buildProposal(grid, proposal, move, _, i, x, y, nextMove, direction, options, needsMove) {
  delete proposal

  for (y in grid) {
    for (x in grid[y]) {
      if (grid[y][x]["spot"] != 1) {
        continue
      }

      if (noNeighbors(grid, x, y)) {
        proposal[y][x]["spot"] = 1
        continue
      }

      needsMove = 1
      blocked = 1

      for (i = 0; i < 4; i++) {
        direction = moves[(move + i) % 4]
        points(direction, options, x, y)

        if (propose(grid, proposal, options)) {
          blocked = 0
          break
        }
      }

      if (blocked) {
        proposal[y][x]["spot"] = 1
      }
    }
  }

  return needsMove
}

function moveProposal(proposal, grid, mins, maxs, _, i, x, y, old_x, old_y, move) {
  delete grid
  delete mins
  delete maxs

  for (y in proposal) {
    for (x in proposal[y]) {
      if (proposal[y][x]["spot"] == 1) {
        grid[y][x]["spot"] = 1
        trackBoundaries(mins, maxs, x, y)
        continue
      }

      if (proposal[y][x]["spot"] > 1) {
        for (i = 1; i <= proposal[y][x]["spot"]; i++) {
          old_x = proposal[y][x]["from"][i]["x"]
          old_y = proposal[y][x]["from"][i]["y"]
          grid[old_y][old_x]["spot"] = 1
          trackBoundaries(mins, maxs, old_x, old_y)
        }
      }
    }
  }
}

function display(grid, mins, maxs, _, x, y) {
  for (y = mins["y"]; y <= maxs["y"]; y++) {
    for (x = mins["x"]; x <= maxs["x"]; x++) {
      printf "%s", grid[y][x]["spot"] ? "#" : "."
    }
    printf "\n"
  }
  printf "\n============================================================\n\n"
}

function solve(grid, _, i, x, y, needsMove, proposal, mins, maxs) {
  while (1) {
    rounds++

    # 1. build proposal
    needsMove = buildProposal(grid, proposal, move)
    move = (move + 1) % 4

    if (!needsMove) {
      printf "Total rounds: %s\n", rounds
      break
    }

    # 2. execute proposed move into grid
    moveProposal(proposal, grid, mins, maxs)

    # printf "ROUND: %s\n", rounds
    # display(grid, mins, maxs)
  }
}

BEGIN {
  moves[0] = "N"
  moves[1] = "S"
  moves[2] = "W"
  moves[3] = "E"
}

{
  y = NR
  n = split($0, spots, //)

  for (x = 1; x <= n; x++) {
    if (spots[x] != "#") continue
    grid[y][x]["spot"] = 1
    trackBoundaries(mins, maxs, x, y)
  }
}

END {
  # display(grid, mins, maxs)
  solve(grid)
}
