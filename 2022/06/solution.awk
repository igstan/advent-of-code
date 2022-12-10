#!/usr/bin/env gawk -f

function solution(window_length) {
  for (i = window_length + 1; i <= length; i++) {
    window = substr($0, i - window_length, window_length)

    delete chars
    for (j=1; j<=window_length; j++) {
      c = substr(window, j, 1)
      chars[c] = 1
    }

    if (length(chars) == window_length) {
      printf("Length: %d\n", i-1)
      next
    }
  }
}

{
  # solution(4)  # part 1
  solution(14) # part 2
}
