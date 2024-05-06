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
  # space[x - 1][y][z] = xor(1, space[x - 1][y][z])
  # space[x + 1][y][z] = xor(1, space[x + 1][y][z])
  # space[x][y - 1][z] = xor(1, space[x][y - 1][z])
  # space[x][y + 1][z] = xor(1, space[x][y + 1][z])
  # space[x][y][z - 1] = xor(1, space[x][y][z - 1])
  # space[x][y][z + 1] = xor(1, space[x][y][z + 1])
  space[x - 1][y][z] += 1
  space[x + 1][y][z] += 1
  space[x][y - 1][z] += 1
  space[x][y + 1][z] += 1
  space[x][y][z - 1] += 1
  space[x][y][z + 1] += 1
}

{
  n = split($0, coords, /,/)
  Geom3D::point(points[NR], coords[1], coords[2], coords[3])
  addFaces(points[NR])

  # OpenSCAD: final shape.
  #
  if (OpenSCAD) {
    for (i = 1; i <= n; i++) {
      printf "translate([%s, %s, %s]) cube(1);\n", coords[1], coords[2], coords[3] > FILENAME ".scad"
    }
  }

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
        if (!space[x][y][z]) {
          continue
        }

        # force numeric
        x += 0
        y += 0
        z += 0

        if ("min" in x_limits[y][z]) {
          x_limits[y][z]["min"] = min(x_limits[y][z]["min"], x)
        } else {
          x_limits[y][z]["min"] = x
        }

        if ("min" in y_limits[x][z]) {
          y_limits[x][z]["min"] = min(y_limits[x][z]["min"], y)
        } else {
          y_limits[x][z]["min"] = y
        }

        if ("min" in z_limits[x][y]) {
          z_limits[x][y]["min"] = min(z_limits[x][y]["min"], z)
        } else {
          z_limits[x][y]["min"] = z
        }

        x_limits[y][z]["max"] = max(x_limits[y][z]["max"], x)
        y_limits[x][z]["max"] = max(y_limits[x][z]["max"], y)
        z_limits[x][y]["max"] = max(z_limits[x][y]["max"], z)
      }
    }
  }

  # printArray(z_limits)

  for (x in space) {
    for (y in space[x]) {
      for (z in space[x][y]) {
        # force numeric
        x += 0
        y += 0
        z += 0

        if (!space[x][y][z]) {
          continue
        }

        # printf "translate([%02s, %02s, %02s]) cube(1);\n", x, y, z

        # printf "x_limits[%s][%s][min]: %s\n", y, z, x_limits[y][z]["min"]
        # printf "y_limits[%s][%s][min]: %s\n", x, z, y_limits[x][z]["min"]
        # printf "z_limits[%s][%s][min]: %s\n", x, y, z_limits[x][y]["min"]

        # if all of a point's coordinates are within min-max bounds, then it must be invisible, so we eliminate it
        # here points are actually faces

        # if (z >= 9 && z <= 11 && y >= 4 && y <= 6 && x >= 4 && x <= 6) {
        #   printf "x=%s; y=%s; z=%s\n", x, y, z
        #   printf "x_limits[%s][%s][min]: %s\n", y, z, x_limits[y][z]["min"]
        #   printf "x_limits[%s][%s][max]: %s\n", y, z, x_limits[y][z]["max"]
        #   printf "y_limits[%s][%s][min]: %s\n", x, z, y_limits[x][z]["min"]
        #   printf "y_limits[%s][%s][max]: %s\n", x, z, y_limits[x][z]["max"]
        #   printf "z_limits[%s][%s][min]: %s\n", x, y, z_limits[x][y]["min"]
        #   printf "z_limits[%s][%s][max]: %s\n", x, y, z_limits[x][y]["max"]
        #   printf "\n"
        # }

        # if ((x == x_limits[y][z]["min"] || x == x_limits[y][z]["max"]) ||
        #     (y == y_limits[x][z]["min"] || y == y_limits[x][z]["max"]) ||
        #     (z == z_limits[x][y]["min"] || z == z_limits[x][y]["max"])) {
        #   # printf "%s %s %s\n", x, y, z
        #   total++
        # }

        if ((x > x_limits[y][z]["min"] && x < x_limits[y][z]["max"]) &&
            (y > y_limits[x][z]["min"] && y < y_limits[x][z]["max"]) &&
            (z > z_limits[x][y]["min"] && z < z_limits[x][y]["max"])) {
          continue
        }

        if (space[x][y][z] == 1) {
          printf "translate([%02s, %02s, %02s]) cube(1);\n", x, y, z
          total++
        }

        # printf "translate([%02s, %02s, %02s]) cube(1);\n", x, y, z
        # total++
      }
    }
  }

  # printf "Total: %s\n", total
}
