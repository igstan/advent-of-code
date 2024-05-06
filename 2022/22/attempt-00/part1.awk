#!/usr/bin/env gawk -f

@include "array"
@include "prelude"
@include "common"

/^$/ {
  getline

  # parse instructions
  n = split($0, chars, //)

  number = ""
  for (i = 1; i <= n; i++) {
    if (chars[i] == "R") {
      instrs[++instr_p] = number
      instrs[++instr_p] = "R"
      number = ""
      continue
    }

    if (chars[i] == "L") {
      instrs[++instr_p] = number
      instrs[++instr_p] = "L"
      number = ""
      continue
    }

    number = number chars[i]
  }

  next
}

{
  y = NR - 1
  n = split($0, rows[y], //)
  max_x = max(max_x, n - 1)
  blocks = 0
  y_stripes[y]["upto"] = n - 1

  for (x = 0; x < n; x++) {
    if (rows[y][x + 1] != " ") {
      if (!("from" in y_stripes[y])) {
        y_stripes[y]["from"] = x
      }

      if (!("from" in x_stripes[x])) {
        x_stripes[x]["from"] = y
      }

      if (rows[y][x + 1] == "#") {
        x_stripes[x]["blocks"][y] = 1
        y_stripes[y]["blocks"][x] = 1
      }
    } else {
      if ("from" in x_stripes[x] && !("upto" in x_stripes[x])) {
        x_stripes[x]["upto"] = y
      }
    }
  }

  for (stripe_x in x_stripes) {
    # printf "stripe_x: %s; n: %s\n", stripe_x, n
    if (stripe_x > n - 1 && !("upto" in x_stripes[stripe_x])) {
      # printf "finalizing: stripe_x=%s; y=%s\n", stripe_x, y
      x_stripes[stripe_x]["upto"] = y
    }
  }

  if (y == 0) {
    for (x = 1; x <= n; x++) {
      if (rows[y][x] == ".") {
        currentPos["x"] = x - 1
        currentPos["y"] = y
        break
      }
    }
  }
}

function showGridUsingYStripes(_, x, y) {
  for (y = 0; y < NR - 2; y++) {
    for (x = 0; x < y_stripes[y]["from"]; x++) {
      printf " "
    }
    for (x = y_stripes[y]["from"]; x <= y_stripes[y]["upto"]; x++) {
      if (x in y_stripes[y]["blocks"]) {
        printf "#"
      } else {
        printf "."
      }
    }
    printf "\n"
  }
}

function showGridUsingXStripes(_, x, y) {
  for (y = 0; y < NR - 2; y++) {
    for (x = 0; x <= max_x; x++) {
      if (x in x_stripes) {
        if (x_stripes[x]["from"] <= y && y < x_stripes[x]["upto"]) {
          if (y in x_stripes[x]["blocks"]) {
            printf "#"
          } else {
            printf "."
          }
        } else {
          printf " " # imperfect, because it adds trailing spaces when run over "input" file
        }
      } else {
        printf ""
      }
    }
    printf "\n"
  }
}

function finalizeXStripes(_, x) {
  for (x in x_stripes) {
    if ("from" in x_stripes[x] && !("upto" in x_stripes[x])) {
      x_stripes[x]["upto"] = NR - 2
    }
  }
}

function moveUp(position, increment, _) {
  printf "MOVING UP %s ...................................................\n", increment
  move(position, increment, x_stripes[position["x"]], "y", -1)
}

function moveDown(position, increment, _) {
  printf "MOVING DOWN %s .................................................\n", increment
  move(position, increment, x_stripes[position["x"]], "y",  1)
}

function moveRight(position, increment, _) {
  printf "MOVING RIGHT %s ................................................\n", increment
  move(position, increment, y_stripes[position["y"]], "x",  1)
}

function moveLeft(position, increment, _) {
  printf "MOVING LEFT %s .................................................\n", increment
  move(position, increment, y_stripes[position["y"]], "x", -1)
}

function solve() {
  moves[0] = "moveUp"
  moves[1] = "moveRight"
  moves[2] = "moveDown"
  moves[3] = "moveLeft"
  moves_l = length(moves)
  moves_p = 1 # move right
  currentOp = moves[moves_p]

  for (i = 1; i <= length(instrs); i++) {
    instr = instrs[i]

    if (instr == "L") {
      moves_p = (moves_p - 1 + moves_l) % moves_l
      currentOp = moves[moves_p]
      # printf "currentOp: %s → %s\n", instr, currentOp
      continue
    }

    if (instr == "R") {
      moves_p = (moves_p + 1 + moves_l) % moves_l
      currentOp = moves[moves_p]
      # printf "currentOp: %s → %s\n", instr, currentOp
      continue
    }

    # printf "currentOp: advance=%s\n", instr
    @currentOp(currentPos, int(instr))

    printf "position after move: %s:%s\n", currentPos["y"] + 1, currentPos["x"] + 1

    if (currentOp == "moveRight") facingSym = ">"
    if (currentOp == "moveDown") facingSym = "v"
    if (currentOp == "moveLeft") facingSym = ">"
    if (currentOp == "moveUp") facingSym = "^"

    rows[currentPos["y"]][currentPos["x"] + 1] = facingSym
  }

  if (currentOp == "moveRight") facing = 0
  if (currentOp == "moveDown") facing = 1
  if (currentOp == "moveLeft") facing = 2
  if (currentOp == "moveUp") facing = 3

  printf "Facing: %s\n", facing
  printf "Password: %s\n", 1000 * (currentPos["y"] + 1) + 4 * (currentPos["x"] + 1) + facing
}

END {
  finalizeXStripes()
  # showGridUsingYStripes()
  # showGridUsingXStripes()
  # printf "---\n"

  # for (y = 0; y < length(rows); y++) {
  #   for (x = 1; x <= length(rows[y]); x++) {
  #     printf "%s", rows[y][x]
  #   }
  #   printf "\n"
  # }
  # printf "\n"

  # printArray(x_stripes)

  # printf "instrs: %s\n", Array::show(instrs)
  # printf "point: %s\n", Show::point(currentPos)

  solve()

  # for (y = 0; y < length(rows); y++) {
  #   for (x = 1; x <= length(rows[y]); x++) {
  #     printf "%s", rows[y][x]
  #   }
  #   printf "\n"
  # }
  # printf "\n"
}
