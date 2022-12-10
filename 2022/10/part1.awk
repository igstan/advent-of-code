#!/usr/bin/env gawk -f

function bump() {
  cycles += 1

  if (cycles in thresholds) {
    signal_strength = cycles * x
    total += signal_strength
  }
}

BEGIN {
  cycles = 0
  x = 1

  thresholds[20] = 1
  thresholds[60] = 1
  thresholds[100] = 1
  thresholds[140] = 1
  thresholds[180] = 1
  thresholds[220] = 1
}

/noop/ {
  bump()
}

/addx/ {
  bump()
  bump()
  x += $2
}

END {
  printf("Total: %s\n", total)
}
