#!/usr/bin/env gawk -f

@include "array"
@include "prelude"

function toDecimalDigit(char) {
  switch (char) {
    case "=": return -2
    case "-": return -1
    default: return int(char)
  }
}

function toDecimal(from, _, i, n, r) {
  n = split(from, chars, //)

  r = 0

  for (i = n; i >= 1; i--) {
    r += toDecimalDigit(chars[i]) * (5 ** (n - i))
  }

  return r
}

function ofDecimal(quotient, _, remainder, carry, rcarry, result) {
  do {
    remainder = quotient % 5
    quotient = int(quotient / 5)
    rcarry = remainder + carry

    if (rcarry <= 2) {
      carry = 0
      result = rcarry result
    } else {
      carry = 1
      if (rcarry == 3) result = "=" result
      if (rcarry == 4) result = "-" result
      if (rcarry == 5) result = "0" result
    }
  } while (quotient)

  return result
}

{
  total += toDecimal($0)
}

END {
  printf "Total[decimal]: %s\n", total
  printf "Total[  SNAFU]: %s\n", ofDecimal(total)
}
