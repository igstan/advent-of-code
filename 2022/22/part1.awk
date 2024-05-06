#!/usr/bin/env gawk -f

@include "array"
@include "prelude"
@include "common"

function showBand(band, _) {
  return sprintf("from=%s; upto=%s; blocks=%s\n", band["from"], band["upto"], showSet(band["blocks"]))
}

function moveUp(position, increment, _) {
  printf "MOVING UP %s ..........................................\n", increment
  move(position, increment, v_bands[position["x"]], "y", -1)
}

function moveDown(position, increment, _) {
  printf "MOVING DOWN %s ........................................\n", increment
  move(position, increment, v_bands[position["x"]], "y",  1)
}

function moveRight(position, increment, _) {
  printf "MOVING RIGHT %s .......................................\n", increment
  move(position, increment, h_bands[position["y"]], "x",  1)
}

function moveLeft(position, increment, _) {
  printf "MOVING LEFT %s ........................................\n", increment
  move(position, increment, h_bands[position["y"]], "x", -1)
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

function displayFromHBands(_, x, y) {
  for (y in h_bands) {
    for (x = 0; x < h_bands[y]["from"]; x++) {
      printf " "
    }

    for (x = h_bands[y]["from"]; x < h_bands[y]["upto"]; x++) {
      if (x in h_bands[y]["blocks"]) {
        printf "#"
      } else {
        printf "."
      }
    }
    printf "\n"
  }
}

function displayFromVBands(_, x, y) {
  for (y = 0; y < NR - 2; y++) {
    for (x in v_bands) {
      if (y < v_bands[x]["from"]) {
        printf " "
        continue
      }

      if (y >= v_bands[x]["upto"]) {
        printf " "
        continue
      }

      if (y in v_bands[x]["blocks"]) {
        printf "#"
      } else {
        printf "."
      }
    }
    printf "\n"
  }
}

function finalizeVBands(v_bands, y, _, x) {
  for (x in v_bands) {
    if (!("upto" in v_bands[x])) {
      v_bands[x]["upto"] = y
    }
  }
}

/^$/ {
  y = NR - 1
  finalizeVBands(v_bands, y)

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

  if (number != "") {
    instrs[++instr_p] = number
  }

  next
}

function parseLine(h_bands, v_bands, currentPos, line, y, _, i, x) {
  n = split($0, chars, //)

  for (i = 1; i <= n; i++) {
    x = i - 1
    if (chars[i] == " ") {
      if ("from" in h_bands[y] && !("upto" in h_bands[y])) {
        h_bands[y]["upto"] = x - 1
      }

      if ("from" in v_bands[x] && !("upto" in v_bands[x])) {
        v_bands[x]["upto"] = y - 1
      }
    } else {
      if (!("from" in h_bands[y])) {
        h_bands[y]["from"] = x
      }

      if (!("from" in v_bands[x])) {
        v_bands[x]["from"] = y
      }

      if (chars[i] == "#") {
        h_bands[y]["blocks"][x] = 1
        v_bands[x]["blocks"][y] = 1
      }
    }
  }

  if (!("upto" in h_bands[y])) {
    h_bands[y]["upto"] = x
  }

  # Finalize v-bands.
  for (x in v_bands) {
    if (x < n) continue
    if (!("upto" in v_bands[x])) {
      v_bands[x]["upto"] = y - 1
    }
  }

  if (y == 0) {
    currentPos["x"] = h_bands[y]["from"]
    currentPos["y"] = 0
  }
}

{
  y = NR - 1
  n = split($0, chars, //)

  parseLine(h_bands, v_bands, currentPos, $0, NR - 1)

  # for (i = 1; i <= n; i++) {
  #   x = i - 1
  #   if (chars[i] == " ") {
  #     if ("from" in h_bands[y] && !("upto" in h_bands[y])) {
  #       h_bands[y]["upto"] = x - 1
  #     }

  #     if ("from" in v_bands[x] && !("upto" in v_bands[x])) {
  #       v_bands[x]["upto"] = y - 1
  #     }
  #   } else {
  #     if (!("from" in h_bands[y])) {
  #       h_bands[y]["from"] = x
  #     }

  #     if (!("from" in v_bands[x])) {
  #       v_bands[x]["from"] = y
  #     }

  #     if (chars[i] == "#") {
  #       h_bands[y]["blocks"][x] = 1
  #       v_bands[x]["blocks"][y] = 1
  #     }
  #   }
  # }

  # if (!("upto" in h_bands[y])) {
  #   h_bands[y]["upto"] = x
  # }

  # # Finalize v-bands.
  # for (x in v_bands) {
  #   if (x < n) continue
  #   if (!("upto" in v_bands[x])) {
  #     v_bands[x]["upto"] = y - 1
  #   }
  # }

  # if (y == 0) {
  #   currentPos["x"] = h_bands[y]["from"]
  #   currentPos["y"] = 0
  # }
}

END {
  for (y in h_bands) {
    printf "h_bands[%03s]: %s", y, showBand(h_bands[y])
  }
  # printf "\n"
  # for (x in v_bands) {
  #   printf "v_bands[%03s]: %s", x, showBand(v_bands[x])
  # }

  printf "instrs: %s\n", Array::show(instrs)

  # printf "H-Bands\n"
  # displayFromHBands()
  # printf "\n\n"

  # printf "V-Bands\n"
  # displayFromVBands()
  # printf "\n"

  solve()
}
