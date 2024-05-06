#!/usr/bin/env gawk -f

@include "prelude"

#
# Explore the options. For each place where there are multiple choices, store
# backtracking positions. Choose one, mark it as taken and explore until we
# reach the End. Store the number of steps taken. Go to the last backtrack
# position and explore a different path until the end.
#
# At the end of the search, the chosen path in the last fork point should be
# marked with the number of steps taken to the end, so that on subsequent
# backtracks we take the most efficient route from there.
#
#   1. -1 means doesn't reach the end
#   2. 0 means path untaken
#   3. N means the number of steps until End
#

{
  n = split($0, letters, //)

  for (i = 1; i <= n; i++) {
    x = i - 1
    y = NR - 1
    heightmap[y][x] = letters[i]

    if (letters[i] == "S") {
      startPoint["x"] = x
      startPoint["y"] = y
      heightmap[y][x] = "a"
    }
  }
}

function fillBacktrackTable(table, LOCAL, x, y) {
  for (y = 0; y < length(heightmap); y++) {
    for (x = 0; x < length(heightmap[y]); x++) {
      table[y][x] = 0
    }
  }
}

function neighbor(src, dst, dir_x, dir_y, LOCAL) {
  dst["x"] = src["x"] + dir_x
  dst["y"] = src["y"] + dir_y
}

function neighbors(src, points, LOCAL, total, k, dst) {
  neighbor(src, dst["U"],  0, -1)
  neighbor(src, dst["D"],  0,  1)
  neighbor(src, dst["L"], -1,  0)
  neighbor(src, dst["R"],  1,  0)

  total = 0

  for (k in dst) {
    if (dst[k]["x"] < 0) continue
    if (dst[k]["x"] >= HEIGHTMAP_WIDTH) continue
    if (dst[k]["y"] < 0) continue
    if (dst[k]["y"] >= HEIGHTMAP_HEIGHT) continue

    total++
    points[total]["x"] = dst[k]["x"]
    points[total]["y"] = dst[k]["y"]
  }

  return total
}

function addBacktrackPoint(point) {
  backtrack_p++
  backtrack_points[backtrack_p]["x"] = point["x"]
  backtrack_points[backtrack_p]["y"] = point["y"]
}

function canClimb(src, dst, LOCAL, src_h, dst_h, src_char, dst_char) {
  src_char = heightmap[src["y"]][src["x"]]
  dst_char = heightmap[dst["y"]][dst["x"]]
  dst_char = dst_char == "E" ? "z" : dst_char
  # printf("src_char: %s; dst_char: %s\n", src_char, dst_char)
  src_h = ord(src_char)
  dst_h = ord(dst_char)
  return (dst_h - src_h) < 2
}

function unvisitedNode(node) {
  return 0 == backtrackTable[node["y"]][node["x"]]
}

function visitable(node) {
  return backtrackTable[node["y"]][node["x"]] >= 0
}

function search(node, shortest_so_far, steps_taken, LOCAL, totalNeibs, shortest, i, seenSteps, steps, neibs) {
  showtable(backtrackTable, " %02s ")
  # showtable(backtrackTable, "%02s", "snapshots-" ++snapshots ".txt")
  # print("--------------------------------------------------------------------")

  if (shortest_so_far > -1) {
    if (steps_taken >= shortest_so_far) {
      return -1
    }
  }

  if (heightmap[node["y"]][node["x"]] == "E") {
    return 0 # end found in zero steps
  } else {
    # Mark this node as currently being explored.
    backtrackTable[node["y"]][node["x"]] = -2

    # Fetch all neighbors
    totalNeibs = neighbors(node, neibs)
    shortest = -1

    for (i = 1; i <= totalNeibs; i++) {
      if (!visitable(neibs[i]) || !canClimb(node, neibs[i])) {
        continue
      }

      seenSteps = backtrackTable[neibs[i]["y"]][neibs[i]["x"]]

      if (seenSteps > 0) {
        if (shortest > -1) {
          shortest = min(shortest, seenSteps + 1)
        } else {
          shortest = seenSteps + 1
        }
      } else {
        printf("visiting %s -> %s\n", heightmap[node["y"]][node["x"]], heightmap[neibs[i]["y"]][neibs[i]["x"]])
        steps = search(neibs[i], shortest, steps_taken + 1)

        if (steps > -1) { # found
          if (shortest > -1) {
            shortest = min(shortest, steps + 1)
          } else {
            shortest = steps + 1
          }

          previous = backtrackTable[neibs[i]["y"]][neibs[i]["x"]]
          if (previous > 0) {
            backtrackTable[neibs[i]["y"]][neibs[i]["x"]] = min(previous, steps)
          } else {
            backtrackTable[neibs[i]["y"]][neibs[i]["x"]] = steps
          }
        }
      }

      printf("shortest: %s\n", shortest)
    }

    # Done visiting this node.
    backtrackTable[node["y"]][node["x"]] = 0

    return shortest
  }
}

END {
  HEIGHTMAP_HEIGHT = length(heightmap)
  HEIGHTMAP_WIDTH = length(heightmap[0])

  backtrack_p = 0 # backtrack stack pointer

  # showtable(heightmap, "%s")
  fillBacktrackTable(backtrackTable)
  # showtable(backtrackTable, "%s")
  # printf("startPoint[x,y]: %s,%s\n", startPoint["x"], startPoint["y"])

  steps = search(startPoint, -1, 0)
  showtable(backtrackTable, " %02s ")
  # showtable(backtrackTable, " %02s ", "snapshots-" ++snapshots ".txt")
  # print("--------------------------------------------------------------------")

  printf("Shortest path: %s\n", steps)
}
