#!/usr/bin/env gawk -f

@include "prelude"

NR == 1 {
  target_y = FILENAME == "test" ? 10 : 2000000
}

{
  match($0, /Sensor at x=([-0-9]+), y=([-0-9]+): closest beacon is at x=([-0-9]+), y=([-0-9]+)/, groups)

  point(sensor, groups[1], groups[2])
  point(beacon, groups[3], groups[4])

  radius = manhattan(sensor, beacon)
  reaches_target = abs(target_y - sensor["y"]) <= radius

  if (!reaches_target) {
    # printf("Skipping record %s [radius=%s; y=%s]\n", NR, radius, sensor["y"])
    next
  }

  covered_area = abs(radius - abs(target_y - sensor["y"]))

  interval(segments[++segment], sensor["x"] - covered_area, sensor["x"] + covered_area)
}

function segmentOrdering(k1, v1, k2, v2, _, d) {
  d = sign(v1["from"] - v2["from"])
  return (d != 0) ? d : sign(v1["upto"] - v2["upto"])
}

function intervalLength(interval) {
  return interval["upto"] - interval["from"]
}

END {
  # printArray(segments)

  n = asort(segments, sorted, "segmentOrdering")

  interval(last, sorted[1]["from"], sorted[1]["upto"])
  total = intervalLength(last)

  for (i = 2; i <= n; i++) {
    if (overlaps(last, sorted[i])) {
      unioned(last, sorted[i], last)
      total = intervalLength(last)
    } else {
      interval(last, sorted[i]["from"], sorted[i]["upto"])
      total += intervalLength(last)
    }
  }

  printf("Total: %s\n", total)
}
