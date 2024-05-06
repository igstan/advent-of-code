#!/usr/bin/env gawk -f

@include "array"
@include "prelude"

function move(position, increment, stripe, axis, direction, _) {
  printf "position: %s\n", Show::point(position)

  Array::copy(local_pos, position)

  local_pos[axis] = position[axis] - stripe["from"]
  printf "local_pos: %s\n", Show::point(local_pos)

  target_local_pos = local_pos[axis] + increment * direction
  printf "target_local_pos: %s\n", target_local_pos

  if (direction < 0) PROCINFO["sorted_in"] = "@ind_num_desc"
  if (direction > 0) PROCINFO["sorted_in"] = "@ind_num_asc"
  for (block_pos in stripe["blocks"]) {
    block_local_pos = block_pos - stripe["from"]
    printf "block_local_pos: %s\n", block_local_pos

    if (direction < 0 && block_local_pos > local_pos[axis]) {
      continue
    }

    if (direction > 0 && block_local_pos < local_pos[axis]) {
      continue
    }

    printf "block_local_pos: %s\n", block_local_pos

    if (direction < 0) {
      if (block_local_pos >= target_local_pos) {
        # printf "XXX\n"
        target_local_pos = block_local_pos - direction
        break
      }
    } else {
      if (block_local_pos <= target_local_pos) {
        # printf "XXX\n"
        target_local_pos = block_local_pos - direction
        break
      }
    }
  }
  delete PROCINFO["sorted_in"]

  printf "target_local_pos: %s\n", target_local_pos
}

function parseStripe(result, string, _, i, n, chars) {
  n = split(string, chars, //)

  for (i = 0; i < n; i++) {
    if (chars[i + 1] == " ") {
      if ("from" in result) {
        result["upto"] = i - 1
        break
      }

      continue
    }

    if (!("from" in result)) {
      result["from"] = i
    }

    if (chars[i + 1] == "#") {
      result["blocks"][i] = 1
    }
  }

  if ("from" in result && !("upto" in result)) {
    result["upto"] = n - 1
  }
}

function test_01() {
  example = "  ..#..#.."
  printf "example: |%s|\n", example
  parseStripe(stripe, example)
  printArray(stripe)

  position["x"] = 2
  position["y"] = 0
  increment = 2

  move(position, increment, stripe, "x", -1)
  # printf "position: %s\n", Show::point(position)
  return position["x"] == 1
}

function suite() {
  for (fn in PROCINFO["identifiers"]) {
    if (PROCINFO["identifiers"][fn] != "user") {
      continue
    }

    if (!match(fn, /^test/)) {
      continue
    }

    if (@fn()) {
      # printf "%s: PASSED\n", fn
      printf "%s: \033[32mOK\033[00m\n", fn
    } else {
      # printf "%s: FAILED\n", fn
      printf "%s: \033[31mFAILED\033[00m\n", fn
    }
  }
}

BEGIN {
  suite()
}
