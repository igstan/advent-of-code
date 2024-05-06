#!/usr/bin/env gawk -f

@include "prelude"

NR == 1 {
  max_rows = FILENAME == "test" ? 20 : 4000000
}

{
  match($0, /Sensor at x=([-0-9]+), y=([-0-9]+): closest beacon is at x=([-0-9]+), y=([-0-9]+)/, groups)
  point(sensors[NR], groups[1], groups[2])
  point(beacons[NR], groups[3], groups[4])
}

function segmentOrdering(k1, v1, k2, v2, _, d) {
  d = sign(v1["from"] - v2["from"])
  return (d != 0) ? d : sign(v1["upto"] - v2["upto"])
}

END {
  for (target_y = 0; target_y <= max_rows; target_y++) {
    segment = 0
    delete segments
    for (k in sensors) {
      # printf("sensor: %s; beacon: %s\n", Show::point(sensors[k]), Show::point(beacons[k]))
      radius = manhattan(sensors[k], beacons[k])
      reaches_target = abs(target_y - sensors[k]["y"]) <= radius

      if (reaches_target) {
        covered_area = abs(radius - abs(target_y - sensors[k]["y"]))
        Interval::of(sensors[k]["x"] - covered_area, sensors[k]["x"] + covered_area, segments[++segment])
        # printf("interval: %s\n", Show::interval(segments[segment]))
      }
    }

    n = asort(segments, sorted, "segmentOrdering")
    printf("y=%s; sorted length: %s\n", target_y, n)

    IntervalSet::one(0, max_rows, result)

    for (i = 1; i <= n; i++) {
      IntervalSet::diffInclusiveUpto(result, sorted[i], remaining)
      IntervalSet::copy(remaining, result)
    }

    if (!IntervalSet::isEmpty(result)) {
      printf("x=%s; y=%s\n", target_y, result[1]["from"])
      tuning_frequency = result[1]["from"] * 4000000 + target_y
      printf("Tuning frequency: %s\n", tuning_frequency)
      break
    }
  }
}
