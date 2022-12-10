#!/usr/bin/env gawk -f

function drawPixel() {
  if (pixel_head >= register_x - 1 && pixel_head <= register_x + 1) {
    printf("#")
  } else {
    printf(".")
  }

  pixel_head += 1

  if (pixel_head % 40 == 0) {
    print("")
    pixel_head = 0
  }
}

function bump() {
  drawPixel()
  cycles += 1
}

BEGIN {
  cycles = 0
  register_x = 1
  pixel_head = 0
}

/noop/ {
  bump()
}

/addx/ {
  bump()
  bump()
  register_x += $2
}
