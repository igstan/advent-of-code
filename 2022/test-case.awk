#!/usr/bin/env gawk -f

@include "test-runner"

function testFoo(result) {
  return Assert::equal(result, 1, 3)
}

function testBar(result) {
  return Assert::equal(result, 1, 1)
}
