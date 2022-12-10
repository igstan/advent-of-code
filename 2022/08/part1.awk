#!/usr/bin/env gawk -f

function probe(max_h, i, j) {
  curr_h = 1 * substr(rows[i], j, 1)

  if (max_h < curr_h) {
    visible[i,j] = 1
    return curr_h
  } else {
    return max_h
  }
}

{
  rows[NR] = $0 # accumulate rows
}

END {
  for (i=2; i<NR; i++) {
    # visible from left
    max_h = 1 * substr(rows[i], 1, 1)
    for (j=2; j<length; j++) {
      max_h = probe(max_h, i, j)
    }

    # visible from right
    max_h = 1 * substr(rows[i], length, 1)
    for (j=length; j>1; j--) {
      max_h = probe(max_h, i, j)
    }
  }

  for (j=2; j<length; j++) {
    # visible from top
    max_h = 1 * substr(rows[1], j, 1)
    for (i=2; i<NR; i++) {
      max_h = probe(max_h, i, j)
    }

    # visible from bottom
    max_h = 1 * substr(rows[NR], j, 1)
    for (i=NR; i>0; i--) {
      max_h = probe(max_h, i, j)
    }
  }

  for (i=2; i<NR; i++) {
    for (j=2; j<length; j++) {
      total += visible[i,j]
    }
  }

  edge_visible = (NR * length) - ((NR - 2) * (length - 2))
  printf("Total edge: %d\n", edge_visible)
  printf("Total inner: %d\n", total)
  printf("Total: %d\n", edge_visible + total)
}
