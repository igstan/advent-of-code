#!/usr/bin/env gawk -f

function abs(a) {
  return a < 0 ? -a : a
}

function sign(a) {
  return a < 0 ? -1 : (a == 0 ? 0 : 1)
}

function pullTail() {
  bearing["x"] = head["x"] - tail["x"]
  bearing["y"] = head["y"] - tail["y"]

  follow = 0

  if (bearing["x"] == 0 || bearing["y"] == 0) {
    if (abs(bearing["x"]) + abs(bearing["y"]) == 2) {
      follow = 1
    }
  } else {
    if (abs(bearing["x"]) + abs(bearing["y"]) == 3) {
      follow = 1
    }
  }

  if (follow) {
    tail["x"] += sign(bearing["x"])
    tail["y"] += sign(bearing["y"])
    trail[tail["x"], tail["y"]] = 1
  }
}

function moveHead(axis, n) {
  head[axis] += n
}

BEGIN {
  head["x"] = 0
  head["y"] = 0
  tail["x"] = 0
  tail["y"] = 0
  trail[0,0] = 1
}

{
  dir = $1
  steps = $2

  if (dir == "L") for (i=0; i<steps; i++) { moveHead("x", -1); pullTail() }
  if (dir == "U") for (i=0; i<steps; i++) { moveHead("y",  1); pullTail() }
  if (dir == "R") for (i=0; i<steps; i++) { moveHead("x",  1); pullTail() }
  if (dir == "D") for (i=0; i<steps; i++) { moveHead("y", -1); pullTail() }
}

END {
  printf("Total: %d\n", length(trail))
}
