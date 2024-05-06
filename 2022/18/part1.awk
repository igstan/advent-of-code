#!/usr/bin/env gawk -f

@include "prelude"

@namespace "Geom3D"

function point(point, x, y, z) {
  point["x"] = x
  point["y"] = y
  point["z"] = z
}

function show(point) {
  return sprintf("(x=%s,y=%s,z=%s)", point["x"], point["y"], point["z"])
}

@namespace "awk"

function addFaces(point, _, x, y, z) {
  x = point["x"] * 2
  y = point["y"] * 2
  z = point["z"] * 2

  # 6 faces
  space[x - 1][y][z] = xor(1, space[x - 1][y][z])
  space[x + 1][y][z] = xor(1, space[x + 1][y][z])
  space[x][y - 1][z] = xor(1, space[x][y - 1][z])
  space[x][y + 1][z] = xor(1, space[x][y + 1][z])
  space[x][y][z - 1] = xor(1, space[x][y][z - 1])
  space[x][y][z + 1] = xor(1, space[x][y][z + 1])
}

{
  n = split($0, coords, /,/)
  Geom3D::point(p, coords[1], coords[2], coords[3])
  addFaces(p)

  # OpenSCAD: final shape.
  #
  # for (i = 1; i <= n; i++) {
  #   printf "translate([%s, %s, %s]) cube(1);\n", coords[1], coords[2], coords[3]
  # }

  # OpenSCAD: step-by-step build of the final shape.
  #
  # for (i = 1; i <= NR; i++) {
  #   printf "translate([%s, %s, %s]) cube(1);\n", 4 * (NR - 1) + points[i]["x"], points[i]["y"], points[i]["z"]
  # }
}

END {
  for (x in space) {
    for (y in space[x]) {
      for (z in space[x][y]) {
        if (space[x][y][z]) total++
      }
    }
  }

  printf "Total: %s\n", total
}
