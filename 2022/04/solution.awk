#!/usr/bin/env gawk -F, -f

function contains(intA, intB) {
  return intA[1] <= intB[1] && intB[2] <= intA[2]
}

function overlaps(intA, intB) {
  return intA[1] <= intB[2] && intA[2] >= intB[1]
}

function part1() {
  split($1, ends1, /-/)
  split($2, ends2, /-/)

  if (contains(ends1, ends2) || contains(ends2, ends1)) {
    total += 1
  }
}

function part2() {
  split($1, ends1, /-/)
  split($2, ends2, /-/)

  if (overlaps(ends1, ends2)) {
    total += 1
  }
}

{
  # part1()
  part2()
}

END {
  printf("Total: %d\n", total)
}
