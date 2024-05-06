@include "allen"

function point(result, x, y) {
  result["x"] = x
  result["y"] = y
}

function showPoint(point) {
  return sprintf("[x=%s; y=%s]", point["x"], point["y"])
}

#
# See: "Competitive Programmer's Handbook", p264, $29.4 Distance functions
#
function euclidian(a, b, _, x_diff, y_diff) {
  x_diff = a["x"] - b["x"]
  y_diff = a["y"] - b["y"]
  return sqrt(x_diff * x_diff + y_diff * y_diff)
}

function manhattan(a, b) {
  return abs(a["x"] - b["x"]) + abs(a["y"] - b["y"])
}

function interval(result, from, upto) {
  result["from"] = from
  result["upto"] = upto
}

function overlaps(a, b) {
  return a["from"] <= b["upto"] && a["upto"] >= b["from"]
}

function unioned(a, b, result) {
  return interval(result, min(a["from"], b["from"]), max(a["upto"], b["upto"]))
}

function intervalLength(interval) {
  return abs(interval["upto"] - interval["from"])
}

@namespace "Interval"

function of(from, upto, result) {
  result["from"] = from
  result["upto"] = upto
}

function show(interval) {
  if ("empty" in interval) {
    return "[]"
  }

  return sprintf("[%s, %s)", interval["from"], interval["upto"])
}

function diff(i1, i2, i3) {
  delete i3

  if (Allen::equal(i1, i2) || Allen::starts(i1, i2) || Allen::during(i1, i2) || Allen::finishes(i1, i2)) {
    i3["length"] = 0
    return
  }

  if (Allen::precedes(i1, i2) || Allen::meets(i1, i2) || Allen::isMetBy(i1, i2) || Allen::isPrecededBy(i1, i2)) {
    i3["length"] = 1
    i3[1]["from"] = i1["from"]
    i3[1]["upto"] = i1["upto"]
    return
  }

  if (Allen::overlaps(i1, i2) || Allen::isFinishedBy(i1, i2)) {
    i3["length"] = 1
    i3[1]["from"] = i1["from"]
    i3[1]["upto"] = i2["from"]
    return
  }


  if (Allen::isStartedBy(i1, i2) || Allen::isOverlappedBy(i1, i2)) {
    i3["length"] = 1
    i3[1]["from"] = i2["upto"]
    i3[1]["upto"] = i1["upto"]
    return
  }

  if (Allen::contains(i1, i2)) {
    i3["length"] = 2
    i3[1]["from"] = i1["from"]
    i3[1]["upto"] = i2["from"]
    i3[2]["from"] = i2["upto"]
    i3[2]["upto"] = i1["upto"]
    return
  }

  printf("Unhandled case: i1=%s; i2=%s\n", show(i1), show(i2))
  exit 1
}

function diffInclusiveUpto(i1, i2, i3) {
  delete i3

  if (Allen::equal(i1, i2) || Allen::starts(i1, i2) || Allen::during(i1, i2) || Allen::finishes(i1, i2)) {
    i3["length"] = 0
    return
  }

  if (Allen::precedes(i1, i2) || Allen::isPrecededBy(i1, i2)) {
    i3["length"] = 1
    i3[1]["from"] = i1["from"]
    i3[1]["upto"] = i1["upto"]
    return
  }

  if (Allen::meets(i1, i2)) {
    i3["length"] = 1
    i3[1]["from"] = i1["from"]
    i3[1]["upto"] = i1["upto"] - 1
    return
  }

  if (Allen::isMetBy(i1, i2)) {
    i3["length"] = 1
    i3[1]["from"] = i1["from"] + 1
    i3[1]["upto"] = i1["upto"]
    return
  }

  if (Allen::overlaps(i1, i2) || Allen::isFinishedBy(i1, i2)) {
    i3["length"] = 1
    i3[1]["from"] = i1["from"]
    i3[1]["upto"] = i2["from"] - 1
    return
  }


  if (Allen::isStartedBy(i1, i2) || Allen::isOverlappedBy(i1, i2)) {
    i3["length"] = 1
    i3[1]["from"] = i2["upto"] + 1
    i3[1]["upto"] = i1["upto"]
    return
  }

  if (Allen::contains(i1, i2)) {
    i3["length"] = 2
    i3[1]["from"] = i1["from"]
    i3[1]["upto"] = i2["from"] - 1
    i3[2]["from"] = i2["upto"] + 2
    i3[2]["upto"] = i1["upto"]
    return
  }

  printf("Unhandled case: i1=%s; i2=%s\n", show(i1), show(i2))
  exit 1
}

@namespace "IntervalSet"

function isEmpty(intervalSet) {
  return intervalSet["length"] == 0
}

function one(from, upto, result) {
  delete result
  result["length"] = 1
  result[1]["from"] = from
  result[1]["upto"] = upto
}

function copy(src, dst, _, k) {
  delete dst
  for (k in src) {
    if (awk::isarray(src[k])) {
      copy(src[k], dst[k])
    } else {
      dst[k] = src[k]
    }
  }
}

function show(intervalSet, _, i, result) {
  if (isEmpty(intervalSet)) {
    return "{}"
  } else {
    result = "{"

    for (i = 1; i <= intervalSet["length"]; i++) {
      if (i > 1) {
        result = result ", "
      }

      result = result Interval::show(intervalSet[i])
    }
  }

  return result "}"
}

function diff(intervalSet, interval, result, _, i, j, ri) {
  delete result

  if (isEmpty(intervalSet)) {
    result["length"] = 0
  } else {
    result["length"] = 0

    for (i = 1; i <= intervalSet["length"]; i++) {
      Interval::diff(intervalSet[i], interval, tempResult)

      for (j = 1; j <= tempResult["length"]; j++) {
        ri = ++result["length"]
        result[ri]["from"] = tempResult[j]["from"]
        result[ri]["upto"] = tempResult[j]["upto"]
      }
    }
  }
}

function diffInclusiveUpto(intervalSet, interval, result, _, i, j, ri) {
  delete result

  if (isEmpty(intervalSet)) {
    result["length"] = 0
  } else {
    result["length"] = 0

    for (i = 1; i <= intervalSet["length"]; i++) {
      Interval::diffInclusiveUpto(intervalSet[i], interval, tempResult)

      for (j = 1; j <= tempResult["length"]; j++) {
        ri = ++result["length"]
        result[ri]["from"] = tempResult[j]["from"]
        result[ri]["upto"] = tempResult[j]["upto"]
      }
    }
  }
}
