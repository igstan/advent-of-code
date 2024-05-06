@namespace "Array"

function empty(array) {
  delete array
}

function show(array, _, result, i, k) {
  result = "["
  PROCINFO["sorted_in"] = "@ind_num_asc"
  for (k in array) {
    if (i > 0) { result = result "," } else i++
    result = result sprintf("%s", array[k])
  }
  delete PROCINFO["sorted_in"]
  result = result "]"
  return result
}

function copy(dst, src, _, k) {
  for (k in src) {
    if (awk::isarray(src[k])) {
      copy(dst[k], src[k])
    } else {
      dst[k] = src[k]
    }
  }
}
