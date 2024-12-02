#!/usr/bin/env gawk -f

@include "Prelude"
@include "Array"

BEGIN {
  Array::empty(left)
  Array::empty(right)
}

{
  left[NR - 1] = $1
  right[$2]++
}

END {
  for (i = 0; i < length(left); i++) {
    dist += left[i] * right[left[i]]
  }

  printf "%s\n", dist
}
