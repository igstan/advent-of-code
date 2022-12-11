#!/usr/bin/env gawk -f

function item_enqueue(monkey_nr, item) {
  monkey_items[monkey_nr, ++monkey_items_count[monkey_nr]] = item
}

function item_dequeue(monkey_nr, LOCALS, head, i) {
  head = monkey_items[monkey_nr,1] # 1-based
  for (i=1; i<monkey_items_count[monkey_nr]; i++) {
    monkey_items[monkey_nr, i] = monkey_items[monkey_nr, i + 1]
  }
  delete monkey_items[monkey_nr, monkey_items_count[monkey_nr]--]
  return head
}

function alter_worry(monkey_nr, item_worry, LOCALS, op, arg, mod, n, per_modulus, i, parts, k, new_worry, rem, res) {
  op = monkey_ops[monkey_nr,1]
  arg = monkey_ops[monkey_nr,2]
  new_worry = ""

  n = split(item_worry, per_modulus, ";")

  # Build for mapping: modulus -> remainder
  if (n == 1) {
    for (k=0; k<length(monkey_div); k++) {
      if (k > 0) {
        new_worry = sprintf("%s;", new_worry)
      }

      mod = monkey_div[k]
      arg2 = arg == "old" ? item_worry : arg

      # https://en.m.wikipedia.org/wiki/Modulo_operation#Properties_(identities)
      if (op == "+") {
        res = (((item_worry % mod) + (arg2 % mod)) % mod)
      }

      if (op == "*") {
        res = (((item_worry % mod) * (arg2 % mod)) % mod)
      }

      # printf("remainder: %s\n", r)
      new_worry = sprintf("%s%s:%s", new_worry, mod, res)

      # printf("new_worry: %s\n", new_worry)
      # print("------------")
    }
  } else {
    # Readjust the mapping
    for (k=1; k<=n; k++) {
      if (k > 1) {
        new_worry = sprintf("%s;", new_worry)
      }

      split(per_modulus[k], parts, ":")
      mod = parts[1]
      rem = parts[2]
      arg2 = arg == "old" ? rem : arg

      # https://en.m.wikipedia.org/wiki/Modulo_operation#Properties_(identities)
      if (op == "+") {
        res = (((rem % mod) + (arg2 % mod)) % mod)
      }

      if (op == "*") {
        res = (((rem % mod) * (arg2 % mod)) % mod)
      }

      # printf("remainder: %s\n", r)
      new_worry = sprintf("%s%s:%s", new_worry, mod, res)
    }
  }

  return new_worry
}

function is_divisible(item_worry, target_mod, LOCALS, n, r, per_modulus, k, parts, mod, rem) {
  n = split(item_worry, per_modulus, ";")
  r = 0 # not divisible

  for (k=1; k<=n; k++) {
    split(per_modulus[k], parts, ":")
    mod = parts[1]
    rem = parts[2]

    if (target_mod == mod) {
      r = (rem == 0) # divisible?
      break
    }
  }

  printf("is_divisible(%s, %s) → %s\n", item_worry, target_mod, r)

  return r
}

function print_monkeys(LOCALS, i, j) {
  for (i=0; i<total_monkey_nr; i++) {
    printf("monkey_nr: %s\n", i)

    for (j=1; j<=monkey_items_count[i]; j++) {
      printf("items[%s]: %s\n", j, monkey_items[i,j])
    }

    for (j=1; j<=2; j++) {
      printf("ops[%s]: %s\n", j, monkey_ops[i,j])
    }

    printf("divisibility: %s\n", monkey_div[i])
    printf("if_true: %s\n", monkey_if_true[i])
    printf("if_false: %s\n", monkey_if_false[i])
    print("-----------------------------------")
  }
}

/^Monkey/ {
  # Monkey Number
  match($0, /([0-9]+)/, parts)
  monkey_nr = parts[1]
  total_monkey_nr += 1
  if (DEBUG) {
    printf("monkey_nr: %s\n", monkey_nr)
  }

  # Items
  getline
  gsub(/  Starting items: /, "", $0)
  split($0, items, /, /)

  monkey_items_count[monkey_nr] = length(items)
  for (i in items) {
    monkey_items[monkey_nr,i] = items[i]
    if (DEBUG) {
      printf("items[%s]: %s\n", i, items[i])
    }
  }

  # Operation
  getline
  gsub(/  Operation: /, "", $0)
  gsub(/= /, "", $0)
  split($0, ops, / +/)
  monkey_ops[monkey_nr,1] = ops[3]
  monkey_ops[monkey_nr,2] = ops[4]

  # Divisibility
  getline
  match($0, /([0-9]+)/, divisibility)
  monkey_div[monkey_nr] = divisibility[1]
  if (DEBUG) {
    printf("divisibility: %s\n", divisibility[1])
  }

  # If true
  getline
  match($0, /([0-9]+)/, if_true)
  monkey_if_true[monkey_nr] = if_true[1]
  if (DEBUG) {
    printf("if_true: %s\n", if_true[1])
  }

  # If false
  getline
  match($0, /([0-9]+)/, if_false)
  monkey_if_false[monkey_nr] = if_false[1]
  if (DEBUG) {
    printf("if_false: %s\n", if_false[1])
  }
}

END {
  for (i=1; i<=total_monkey_nr; i++) {
    monkey_inspected_items[i] = 0
  }

  # print_monkeys()

  snapshots[1] = 1
  snapshots[20] = 1
  snapshots[1000] = 1
  snapshots[2000] = 1
  snapshots[3000] = 1
  snapshots[4000] = 1
  snapshots[5000] = 1
  snapshots[6000] = 1
  snapshots[7000] = 1
  snapshots[8000] = 1
  snapshots[9000] = 1
  snapshots[10000] = 1

  monkey_rounds = 10000

  for (iii=0; iii<monkey_rounds; iii++) {
    printf("monkey_rounds: %s\n", iii)

    for (i=1; i<=total_monkey_nr; i++) {
      printf("monkey_inspected_items[%s]: %s\n", i, monkey_inspected_items[i])
    }
    print("------------------------")

    for (i=0; i<total_monkey_nr; i++) {
      printf("monkey_nr: %s\n", i)
      # print_monkeys()

      while (monkey_items_count[i] > 0) {
        monkey_inspected_items[i + 1]++
        item_worry = item_dequeue(i)
        printf("    item_worry[%s]: %s\n", i, item_worry)
        new_item_worry = alter_worry(i, item_worry)
        printf("new_item_worry[%s]: %s\n", i, new_item_worry)

        if (is_divisible(new_item_worry, monkey_div[i])) {
          printf("throwing to monkey: %s\n", monkey_if_true[i])
          item_enqueue(monkey_if_true[i], new_item_worry)
        } else {
          printf("throwing to monkey: %s\n", monkey_if_false[i])
          item_enqueue(monkey_if_false[i], new_item_worry)
        }
      }
      print("-----------------------------------")
    }
  }

  asort(monkey_inspected_items, sorted_items, "@val_num_desc")
  total = sorted_items[1] * sorted_items[2]

  printf("Total: %s\n", total)
}
