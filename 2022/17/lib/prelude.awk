@include "geom"
@include "show"

BEGIN {
  fillASCII()
}

function log10(a) {
  return log(a) / log(10)
}

function countDigits(n) {
  return int(log10(n)) + 1
}

function fillASCII(LOCAL, upper_a, upper_b, letters, i) {
  upper_a = 65
  lower_a = 97
  letters = 25

  for (i = upper_a; i <= upper_a + letters; i++) {
    ASCII[sprintf("%c", i)] = i
  }

  for (i = lower_a; i <= lower_a + letters; i++) {
    ASCII[sprintf("%c", i)] = i
  }
}

function ord(chr) {
  return ASCII[chr]
}

function chr(ord) {
  return sprintf("%c", ord + 0)
}

function max(a, b) {
  return b > a ?  b : a
}

function min(a, b) {
  return b < a ?  b : a
}

function abs(a) {
  return a < 0 ? -a : a
}

function sign(a) {
  return a < 0 ? -1 : (a == 0 ? 0 : 1)
}

function showtable(table, fmt, file, LOCAL, height, width, x, y) {
  height = length(table)
  fmt = fmt ? fmt : " %s "

  for (y = 0; y < height; y++) {
    width = length(table[y])

    for (x = 0; x < width; x++) {
      if (file) {
        printf(fmt, table[y][x]) > file
      } else {
        printf(fmt, table[y][x])
      }
      # if (x > 0) printf("│")
      #
      # if (y % 2) {
      #   printf("\033[0;31m" fmt "\033[0m", table[y][x]) # bright red
      # } else {
      #   printf("\033[0;32m" fmt "\033[0m", table[y][x]) # bright green
      # }
    }

    if (file) {
      printf("\n") > file
    } else {
      printf("\n")
    }
  }
}

function showArray(array, LOCAL, result, k, i, key) {
  if (!isarray(array)) {
    printf("%s: %s", typeof(array), array)
    return
  }

  result = "{"

  for (k in array) {
    key = sprintf("\"%s\": ", k)

    if (i++ > 0) {
      result = result ", "
    }

    if (isarray(array[k])) {
      result = result key showArray(array[k])
    } else {
      if (typeof(array[k]) == "str") {
        result = result key sprintf("\"%s\"", array[k])
      } else {
        result = result key sprintf("\"%s\"", array[k])
      }
    }
  }

  result = result "}"

  return result
}

function printArray(array) {
  printf("%s\n", showArray(array))
}

function join(array, sep, start, end, LOCAL, result, i) {
  if (sep == "") {
    sep = " "
  } else if (sep == SUBSEP) { # magic value
    sep = ""
    result = array[start]
  }

  for (i = start + 1; i <= end; i++) {
    result = result sep array[i]
  }

  return result
}
