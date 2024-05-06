#!/usr/bin/env gawk -f

@include "prelude"
@include "union-find"

BEGIN {
  SIZE = 40

  # "echo $RANDOM" | getline RANDOM
  # printf "RANDOM: %s\n\n", RANDOM
  srand() # Set random seed using time of day.

  UnionFind::empty(ufset)

  for (y = 0; y < SIZE / 2; y++) {
    for (x = 0; x < SIZE; x++) {
      grid[y][x] = rand() >= 0.4

      if (grid[y][x]) {
        if (y == 0) {
          UnionFind::union(ufset, x ":" y, "above")
        }

        if (y > 0 && grid[y - 1][x]) {
          UnionFind::union(ufset, x ":" y, x ":" (y - 1))
        }

        if (x > 1 && grid[y][x - 1]) {
          UnionFind::union(ufset, x ":" y, (x - 1) ":" y)
        }

        if (y == (SIZE / 2 - 1)) {
          UnionFind::union(ufset, x ":" y, "below")
        }
      }
    }
  }

  for (y = 0; y < SIZE / 2; y++) {
    for (x = 0; x < SIZE; x++) {
      if (grid[y][x]) {
        printf " "
      } else {
        printf "#"
      }
    }
    printf "\n"
  }

  printf "\n"
  printf "percolates: %s\n", UnionFind::connected(ufset, "above", "below")
}
