#!/usr/bin/env gawk -f

function abs(a) {
  return a < 0 ? -a : a
}

function sign(a) {
  return a < 0 ? -1 : (a == 0 ? 0 : 1)
}

# `i` is a local variable. Declaring it as a parameter is the only way to
# declare a local variable in AWK. If we don't do this, the outer `i` in
# the loop that calls `pullTail` will interfere with us.
function pullTail(i) {
  for (i=1; i<KNOTS_NR; i++) {
    # printBoard()

    bearing["x"] = knots[i - 1,"x"] - knots[i,"x"]
    bearing["y"] = knots[i - 1,"y"] - knots[i,"y"]

    follow = 0

    if (bearing["x"] == 0 || bearing["y"] == 0) {
      if (abs(bearing["x"]) + abs(bearing["y"]) == 2) {
        follow = 1
      }
    } else {
      if (abs(bearing["x"]) + abs(bearing["y"]) >= 3) {
        follow = 1
      }
    }

    if (!follow) {
      break
    }

    if (follow) {
      knots[i,"x"] += sign(bearing["x"])
      knots[i,"y"] += sign(bearing["y"])

      # printf("i: %s\n", i)
      if (i == (KNOTS_NR - 1)) {
        trail[knots[i,"x"], knots[i,"y"]] = 1
      }
    }
  }
}

function moveHead(axis, n) {
  knots[0,axis] += n
}

function printBoard(  i, x, y) {
  w_board = 26
  h_board = 21
  x_displacement = 11
  y_displacement = 5

  print("--------------------------------------------------------------------")

  for (yi=h_board; yi>=0; yi--) {
    for (xi=0; xi<w_board; xi++) {
      x = xi - x_displacement
      y = yi - y_displacement

      populated = 0
      for (i=0; i<KNOTS_NR; i++) {
        if (knots[i,"x"] == x && knots[i,"y"] == y) {
          if (i == 0) {
            printf("H")
          } else {
            printf("%d", i)
          }
          populated = 1
          break
        }
      }

      if (!populated) {
        if (x == 0 && y == 0) {
          printf("s")
        } else {
          printf(".")
        }
      }
    }
    print("")
  }
}

BEGIN {
  KNOTS_NR=10

  for (i=0; i<KNOTS_NR; i++) {
    knots[i,"x"] = 0
    knots[i,"y"] = 0
  }

  trail[0,0] = 1
}

{
  dir = $1
  steps = $2

  if (dir == "L") {
    # printBoard()
    for (i=0; i<steps; i++) { moveHead("x", -1); pullTail() }
  }

  if (dir == "U") {
    # printBoard()
    for (i=0; i<steps; i++) { moveHead("y",  1); pullTail() }
  }

  if (dir == "R") {
    # printBoard()
    for (i=0; i<steps; i++) { moveHead("x",  1); pullTail() }
  }

  if (dir == "D") {
    # printBoard()
    for (i=0; i<steps; i++) { moveHead("y", -1); pullTail() }
  }
}

END {
  printf("Total: %d\n", length(trail))
}
