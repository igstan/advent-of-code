@namespace "Show"

function point(point) {
  return sprintf("[x=%s; y=%s]", point["x"], point["y"])
}

function interval(interval) {
  if ("empty" in interval) {
    return "[]"
  }

  return sprintf("[%s - %s]", interval["from"], interval["upto"])
}
