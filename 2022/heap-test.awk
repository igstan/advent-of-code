#!/usr/bin/env gawk -f

@include "prelude"
@include "array"
@include "heap"

BEGIN {
  Heap::empty(heap)
  # printArray(heap)
  printf "heap: %s\n", Heap::show(heap)

  Heap::add(heap, 1)
  # printArray(heap)
  printf "heap: %s\n", Heap::show(heap)
  printf "max: %s\n", Heap::top(heap)

  Heap::add(heap, 2)
  # printArray(heap)
  printf "heap: %s\n", Heap::show(heap)
  printf "max: %s\n", Heap::top(heap)

  Heap::add(heap, 5)
  # printArray(heap)
  printf "heap: %s\n", Heap::show(heap)
  printf "max: %s\n", Heap::top(heap)
  # printf "deleteMax: %s\n", Heap::pop(heap)
  # printArray(heap)

  Heap::add(heap, 3)
  # printArray(heap)
  printf "heap: %s\n", Heap::show(heap)
  printf "max: %s\n", Heap::top(heap)

  Heap::add(heap, 4)
  # printArray(heap)
  printf "heap: %s\n", Heap::show(heap)
  printf "max: %s\n", Heap::top(heap)

  split("SORTEXAMPLE", values, //)
  printf "values: %s\n", Array::show(values)
  Heap::sort(values)
  printf "sorted: %s\n", Array::show(values)
}
