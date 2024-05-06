#!/usr/bin/env gawk -f

@include "prelude"

BEGIN {
  # Interval::of(1, 10, i1)
  # Interval::of(3, 5, i2)

  # printf("i1: %s\n", Interval::show(i1))
  # printf("i2: %s\n", Interval::show(i2))

  # Interval::diff(i1, i2, is3)
  # printf("i1 - i2 = %s\n", IntervalSet::show(is3))
  # Interval::of(7, 9, i4)
  # printf("i4: %s\n", Interval::show(i4))
  # IntervalSet::diff(is3, i4, is5)
  # printf("is3 - i4 = %s\n", IntervalSet::show(is5))

  # Interval::diff(i2, i1, i3)
  # printf("i2 - i1 = %s\n", IntervalSet::show(i3))

  # Interval::of(1, 7, i1)
  # Interval::of(3, 10, i2)

  # printf("i1: %s\n", Interval::show(i1))
  # printf("i2: %s\n", Interval::show(i2))

  # Interval::diff(i1, i2, i3)
  # printf("i1 - i2 = %s\n", IntervalSet::show(i3))

  # Interval::diff(i2, i1, i3)
  # printf("i2 - i1 = %s\n", IntervalSet::show(i3))

  Interval::of(3, 20, i1)
  Interval::of(3, 13, i2)

  printf("i1: %s\n", Interval::show(i1))
  printf("i2: %s\n", Interval::show(i2))

  Interval::diff(i1, i2, is3)
  printf("i1 - i2 = %s\n", IntervalSet::show(is3))
}
