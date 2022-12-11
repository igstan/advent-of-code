#!/usr/bin/env gawk -f

BEGIN {
  # n = split("3 4 + 2 *", stack, / /)
  n = split("3 4 * 5 6 * +", stack, / /)

  if (DEBUG) {
    for (i=1; i<=n; i++) {
      printf("stack[%s]: %s\n", i, stack[i])
    }
    print("-----------")
  }

  stack_p = 0

  while (stack_p < n) {
    top = stack[++stack_p]

    if (top == "+" || top == "*") {
      # pop arguments
      arg2 = values[value_p--]
      arg1 = values[value_p--]

      if (top == "+") {
        values[++value_p] = arg1 + arg2
      }

      if (top == "*") {
        values[++value_p] = arg1 * arg2
      }

      if (DEBUG) {
        printf("oper: %s\n", top)
        printf("arg1: %s\n", arg1)
        printf("arg2: %s\n", arg2)
      }
    } else {
      values[++value_p] = top
    }

    if (DEBUG) {
      for (v in values) {
        printf("value[%s]: %s\n", v, values[v])
      }
      print("-----------")
    }
  }

  printf("result: %s\n", values[1])
}
