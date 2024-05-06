#!/usr/bin/env gawk -f

@namespace "BandIterator"

function nextBlock(point) {
  point["x"] = 1
  point["y"] = 1
  return 1
}
