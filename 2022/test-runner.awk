@include "prelude"

BEGIN {
  printArray(PROCINFO["identifiers"])

  for (fn in PROCINFO["identifiers"]) {
    if (PROCINFO["identifiers"][fn] != "user") {
      continue
    }

    if (!match(fn, /test/)) {
      continue
    }

    # printf "fn: %s\n", fn
    if (!@fn(result)) {
      # printf "Test failed: %s. Detail: %s\n", fn, result["message"]
    } else {
      # printf "Test passed: %s\n", fn
    }
  }
}

@namespace "Assert"

function equal(result, expected, actual, message) {
  delete result

  if (expected != actual) {
    result["failure"] = 1
    result["message"] = message ? message : sprintf("expected: %s; got: %s", expected, actual)
    result["actual"] = actual
    result["expected"] = actual
    return 0
  } else {
    result["success"] = 1
    return 1
  }
}

@namespace "Quux"

function testFoo(result) {
  return Assert::equal(result, 1, 2, "1 != 2")
}

@namespace "awk"
