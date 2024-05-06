@namespace "Heap"

@include "array"

function empty(heap) {
  Array::empty(heap)
  Array::empty(heap["vals"])
  heap["size"] = 0
}

function size(heap) {
  return heap["size"]
}

function isEmpty(heap) {
  return heap["size"] == 0
}

function _exch(heap, a, b, _, t) {
  t = heap["vals"][a]
  heap["vals"][a] = heap["vals"][b]
  heap["vals"][b] = t
}

function _swim(heap, _, e, p) {
  e = heap["size"]
  p = int(e / 2)

  while (e > 1 && p in heap["vals"] && heap["vals"][p] < heap["vals"][e]) {
    _exch(heap, p, e)
    e = p
    p = int(e / 2)
  }
}

function _sink(heap, k, size, _, j) {
  while (2 * k <= size) {
    j = 2 * k
    if (j < size && heap["vals"][j] < heap["vals"][j + 1]) j++
    if (heap["vals"][k] >= heap["vals"][j]) break
    _exch(heap, k, j)
    k = j
  }
}

function _assertNonEmpty(heap) {
  if (isEmpty(heap)) {
    print "empty heap"
    exit 1
  }
}

function add(heap, value) {
  heap["vals"][++heap["size"]] = value
  _swim(heap)
}

function top(heap, _) {
  _assertNonEmpty(heap)
  return heap["vals"][1]
}

function pop(heap, _, max) {
  _assertNonEmpty(heap)
  max = heap["vals"][1]
  _exch(heap, 1, heap["size"]--)
  _sink(heap, 1, heap["size"])
  delete heap["vals"][heap["size"] + 1]
  return max
}

function sort(values, _, k, size, heap) {
  size = length(values)

  heap["size"] = size
  for (k = 1; k <= size; k++) {
    heap["vals"][k] = values[k]
  }

  for (k = int(size / 2); k >= 1; k--) {
    _sink(heap, k, size)
    # printf "HEAP: %s\n", show(heap)
  }

  while (size > 1) {
    _exch(heap, 1, size)
    _sink(heap, 1, --size)
    # printf "HEAP: %s\n", show(heap)
  }

  for (k = 1; k <= heap["size"]; k++) {
    values[k] = heap["vals"][k]
  }
}

function show(heap) {
  return Array::show(heap["vals"])
}
