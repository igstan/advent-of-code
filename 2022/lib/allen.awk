@namespace "Allen"

#
# See: Software Support for Calculations in Allen's Interval Algebra
#

function precedes(a, b) {
  return a["upto"] < b["from"]
}

function meets(a, b) {
  return a["upto"] == b["from"]
}

function overlaps(a, b) {
  return \
    a["from"] < b["from"] &&
    a["upto"] > b["from"] &&
    a["upto"] < b["upto"]
}

function isFinishedBy(a, b) {
  return a["from"] < b["from"] && a["upto"] == b["upto"]
}

function contains(a, b) {
  return a["from"] < b["from"] && a["upto"] > b["upto"]
}

function starts(a, b) {
  return a["from"] == b["from"] && a["upto"] < b["upto"]
}

function equal(a, b) {
  return a["from"] == b["from"] && a["upto"] == b["upto"]
}

function isStartedBy(a, b) {
  return starts(b, a)
}

function during(a, b) {
  return contains(b, a)
}

function finishes(a, b) {
  return isFinishedBy(b, a)
}

function isOverlappedBy(a, b) {
  return overlaps(b, a)
}

function isMetBy(a, b) {
  return meets(b, a)
}

function isPrecededBy(a, b) {
  return precedes(b, a)
}
