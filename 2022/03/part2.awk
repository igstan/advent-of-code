#!/usr/bin/env gawk -f

BEGIN {
  # upper case
  for (i=65; i<=90; i++) {
    priority[sprintf("%c", i)] = i - 65 + 27
  }

  # lower case
  for (i=97; i<=122; i++) {
    priority[sprintf("%c", i)] = i - 97 + 1
  }
}

{
  delete data

  len = length($0)
  for (i=1; i<=len; i++) {
    c = substr($0, i, 1)
    if (data[c] == 0) {
      data[c] += 1
    }
  }

  getline
  len = length($0)
  for (i=1; i<=len; i++) {
    c = substr($0, i, 1)
    if (data[c] == 1) {
      data[c] += 1
    }
  }

  getline
  len = length($0)
  for (i=1; i<=len; i++) {
    c = substr($0, i, 1)
    if (data[c] == 2) {
      printf("%s\n", c)
      total += priority[c]
      next
    }
  }
}

END {
  printf("Total: %d\n", total)
}
