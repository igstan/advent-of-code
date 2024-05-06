#!/usr/bin/env gawk -f

@include "array"
@include "prelude"
@include "common"

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

function test_01(_, example, stripe, position, increment) {
  example = "...#.......#"
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 0
  position["y"] = 0
  increment = 1

  move(position, increment, stripe, "x", 1)
  return position["x"] == 1
}

function test_02(_, example, stripe, position, increment) {
  example = "...#.......#"
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 0
  position["y"] = 0
  increment = 2

  move(position, increment, stripe, "x", 1)
  return position["x"] == 2
}

function test_03(_, example, stripe, position, increment) {
  example = "...#.......#"
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 0
  position["y"] = 0
  increment = 3

  move(position, increment, stripe, "x", 1)
  # printf "position: %s\n", Show::point(position)
  return position["x"] == 2
}

function test_04(_, example, stripe, position, increment) {
  example = "...#.......#"
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 0
  position["y"] = 0
  increment = 4

  move(position, increment, stripe, "x", 1)
  return position["x"] == 2
}

function test_05(_, example, stripe, position, increment) {
  example = "...#.......#"
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 0
  position["y"] = 0
  increment = 1

  move(position, increment, stripe, "x", -1)
  # printf "position: %s\n", Show::point(position)
  return position["x"] == 0
}

function test_06(_, example, stripe, position, increment) {
  example = "...#.......#"
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 0
  position["y"] = 0
  increment = 2

  move(position, increment, stripe, "x", -1)
  return position["x"] == 0
}

function test_07(_, example, stripe, position, increment) {
  example = "...#.......#"
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 5
  position["y"] = 0
  increment = 1

  move(position, increment, stripe, "x", -1)
  # printf "position: %s\n", Show::point(position)
  return position["x"] == 4
}

function test_08(_, example, stripe, position, increment) {
  example = "...#.......#"
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 5
  position["y"] = 0
  increment = 2

  move(position, increment, stripe, "x", -1)
  # printf "position: %s\n", Show::point(position)
  return position["x"] == 4
}

function test_09(_, example, stripe, position, increment) {
  example = "...#.......#"
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 6
  position["y"] = 0
  increment = 1

  move(position, increment, stripe, "x", 1)
  # printf "position: %s\n", Show::point(position)
  return position["x"] == 7
}

function test_10(_, example, stripe, position, increment) {
  example = "...#.....#.."
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 2
  position["y"] = 0
  increment = 4

  move(position, increment, stripe, "x", -1)
  # printf "position: %s\n", Show::point(position)
  return position["x"] == 10
}

function test_11(_, example, stripe, position, increment) {
  example = "...#.....#.."
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 10
  position["y"] = 0
  increment = 4

  move(position, increment, stripe, "x", 1)
  # printf "position: %s\n", Show::point(position)
  return position["x"] == 2
}

function test_12(_, example, stripe, position, increment) {
  example = "...."
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 1
  position["y"] = 0
  increment = 5

  move(position, increment, stripe, "x", 1)
  # printf "position: %s\n", Show::point(position)
  return position["x"] == 2
}

function test_13(_, example, stripe, position, increment) {
  example = "...."
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 0
  position["y"] = 1
  increment = 5

  move(position, increment, stripe, "y", 1)
  # printf "position: %s\n", Show::point(position)
  return position["y"] == 2
}

function test_14(_, example, stripe, position, increment) {
  example = "        ...#"
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 8
  position["y"] = 0
  increment = 10

  move(position, increment, stripe, "x", 1)
  # printf "position: %s\n", Show::point(position)
  return position["x"] == 10
}

function test_15(_, example, stripe, position, increment) {
  example = "........#..."
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 10
  position["y"] = 0
  increment = 5

  move(position, increment, stripe, "x", 1)
  # printf "position: %s\n", Show::point(position)
  return position["x"] == 3
}

function test_16(_, example, stripe, position, increment) {
  example = ".......#...."
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 0
  position["y"] = 0
  increment = 2

  move(position, increment, stripe, "y", -1)
  # printf "position: %s\n", Show::point(position)
  return position["y"] == 10
}

function test_17(_, example, stripe, position, increment) {
  example = ".......#...."
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 0
  position["y"] = 0
  increment = 3

  move(position, increment, stripe, "x", -1)
  # printf "position: %s\n", Show::point(position)
  return position["x"] == 9
}

function test_18(_, example, stripe, position, increment) {
  example = "........#..."
  parseStripe(stripe, example)
  # printArray(stripe)

  position["x"] = 10
  position["y"] = 0
  increment = 5

  move(position, increment, stripe, "x", 1)
  # printf "position: %s\n", Show::point(position)
  return position["x"] == 3
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

  # printf "result: %s\n", test_01()
  # printf "result: %s\n", test_02()
  # printf "result: %s\n", test_03()
  # printf "result: %s\n", test_04()
  # printf "result: %s\n", test_05()
  # printf "result: %s\n", test_06()
  # printf "result: %s\n", test_07()
  # printf "result: %s\n", test_08()
  # printf "result: %s\n", test_09()
  # printf "result: %s\n", test_10()
  # printf "result: %s\n", test_11()
  # printf "result: %s\n", test_12()
  # printf "result: %s\n", test_13()
  # printf "result: %s\n", test_14()
  # printf "result: %s\n", test_15()
  # printf "result: %s\n", test_16()
  # printf "result: %s\n", test_17()
  # printf "result: %s\n", test_18()
}
