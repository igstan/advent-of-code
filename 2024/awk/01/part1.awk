#!/usr/bin/env gawk -f

@include "Prelude"
@include "Array"

BEGIN {
  Array::empty(left)
  Array::empty(right)
}

{
  left[NR - 1] = $1
  right[NR - 1] = $2
}

END {
  asort(left)
  asort(right)

  for (i = 0; i < length(left); i++) {
    dist += abs(left[i] - right[i])
  }

  printf "%s\n", dist
}
