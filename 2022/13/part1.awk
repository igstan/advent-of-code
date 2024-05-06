#!/usr/bin/env gawk -f

@include "prelude"

# array ::= "[" (member ("," member)*)? "]"
# member ::= number | array

@namespace "parser"

function ofString(str, parser) {
  parser["pos"] = 1
  split(str, parser["chars"], //)
}

function elem(input) {
  # printf("input[pos=%s]: %s\n", input["pos"], input["chars"][input["pos"]])
  return input["chars"][input["pos"]]
}

function advance(input) {
  # printf("advance: %s → %s\n", input["pos"], input["pos"] + 1)
  return ++input["pos"]
}

function backtrack(input, pos) {
  # printf("backtracking: %s ← %s\n", pos, input["pos"])
  input["pos"] = pos
}

function number(input, result, i, _, char, num) {
  char = elem(input)

  while (char ~ /[0-9]/) {
    advance(input)
    num = num char
    char = elem(input)
  }

  if (num != "") {
    result[i] = awk::strtonum(num)
    return 1
  } else {
    return 0
  }
}

function member(input, result, i, _, num_result) {
  if (number(input, result, i)) {
    return 1
  } else {
    if (array(input, result[i])) {
      return 1
    } else {
      delete result[i]
      return 0
    }
  }
}

function array(input, result, i, _, original_pos, backtrack_pos) {
  delete result # Enforce array type on result, otherwise `number` will crash.

  if (elem(input) != "[") {
    # printf("Expected: '[', but found '%s'.\n", elem(input))
    return 0
  }

  original_pos = advance(input)

  if (member(input, result, i + 1)) {
    i++

    while (elem(input) == ",") {
      backtrack_pos = advance(input)

      if (member(input, result, i + 1)) {
        i++
      } else {
        backtrack(input, backtrack_pos)
        break
      }
    }
  }

  if (elem(input) == "]") {
    advance(input)
    return 1
  } else {
    # printf("Expected: ']', but found '%s'.\n", elem(input))
    backtrack(input, original_pos)
    return 0
  }
}

@namespace "awk"

function compare(line1, line2, _, i, n1, n2, r, tmp) {
  if (isarray(line1) && isarray(line2)) {
    # printf("Compare %s vs %s\n", showArray(line1), showArray(line2))

    while (++i) {
      if (!(i in line1) && !(i in line2)) {
        return 0
      }

      if (!(i in line1)) {
        return -1
      }

      if (!(i in line2)) {
        return 1
      }

      r = compare(line1[i], line2[i])
      if (r != 0) {
        return r
      }
    }
  }

  if (!isarray(line1) && isarray(line2)) {
    tmp[1] = line1
    return compare(tmp, line2)
  }

  if (!isarray(line2) && isarray(line1)) {
    tmp[1] = line2
    return compare(line1, tmp)
  }

  # printf("Compare %s vs %s\n", line1, line2)

  if (line1 < line2) return -1
  if (line1 > line2) return 1
  return 0
}

function parseLine(str, line, _, prs) {
  parser::ofString(str, prs)
  parser::array(prs, line)
}

/^$/ {
  next
}

{
  packet_i++

  parseLine($0, line1)
  getline
  parseLine($0, line2)

  ordered = compare(line1, line2)

  if (ordered == -1) {
    total += packet_i
  }

  # printf("== Pair %s ==\n", packet_i)
  # printArray(line1)
  # printArray(line2)
  # printf("compare[packet_i=%s]: %s\n", packet_i, ordered)
  # printf("\n")
}

END {
  printf("Total: %s\n", total)
}
