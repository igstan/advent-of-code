function alter_worry_old(monkey_nr, item_worry, LOCALS, op, arg) {
  # RPN order
  op = monkey_ops[monkey_nr,1]
  arg = monkey_ops[monkey_nr,2]
  arg = arg == "old" ? item_worry : arg
  return sprintf("%s %s %s", item_worry, arg, op)
}

function is_divisible_old(item_worry, mod, LOCALS, i, n, arg1, arg2, oper, result) {
  n = split(item_worry, operands, /,/)

  if (n == 1) {
    return operands[1] % mod
  }

  # for(i=1; i<=n; i++) {
  #   printf("operands[%s]: %s\n", i, operands[i])
  # }

  i = 1
  arg1 = operands[i++]
  oper = operands[i++]
  arg2 = operands[i++]

  # printf("arg1: %s\n", arg1)
  # printf("oper: %s\n", oper)
  # printf("arg2: %s\n", arg2)

  # https://en.m.wikipedia.org/wiki/Modulo_operation#Properties_(identities)
  if (oper == "*") {
    result = ((arg1 % mod) * (arg2 % mod)) % mod
  }
  if (oper == "+") {
    result = ((arg1 % mod) + (arg2 % mod)) % mod
  }

  while (i<=n) {
    oper = operands[i++]
    arg2 = operands[i]
    # printf("oper: %s\n", oper)
    # printf("arg2: %s\n", arg2)
    if (oper == "*") {
      result = ((result % mod) * (arg2 % mod)) % mod
    }
    if (oper == "+") {
      result = ((result % mod) + (arg2 % mod)) % mod
    }
  }

  # printf("is_divisible(\"%s\", %s) → %s → %s\n", item_worry, mod, result, result == 0)

  return result == 0
}

function is_divisible(item_worry, mod, LOCALS, stack, i, n, arg1, arg2, oper, result, values, stack_p, value_p) {
  n = split(item_worry, stack, / /)

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

      # https://en.m.wikipedia.org/wiki/Modulo_operation#Properties_(identities)
      if (top == "+") {
        values[++value_p] = (((arg1 % mod) + (arg2 % mod)) % mod)
      }

      if (top == "*") {
        values[++value_p] = (((arg1 % mod) * (arg2 % mod)) % mod)
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
        printf("values[%s]: %s\n", v, values[v])
      }
      print("-----------")
    }
  }

  # printf("values[1]: %s\n", values[1])
  result = values[1] == 0
  # printf("result: %s\n", result)
  return result
}

BEGIN {
  # is_divisible("3 1 + 2 *", 7)
  # is_divisible("3 4 + 2 *", 7)
}
