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

function alter_worry(monkey_nr, item_worry, LOCALS, op, arg) {
  op = monkey_ops[monkey_nr,3]
  arg = monkey_ops[monkey_nr,4]

  if (op == "+") {
    arg = arg == "old" ? item_worry : arg
    return item_worry + arg
  }

  if (op == "*") {
    arg = arg == "old" ? item_worry : arg
    return item_worry * arg
  }

  print("unhandled")
  exit 1
}

function print_monkeys(LOCALS, i, j) {
  for (i=0; i<total_monkey_nr; i++) {
    printf("monkey_nr: %s\n", i)

    for (j=1; j<=monkey_items_count[i]; j++) {
      printf("items[%s]: %s\n", j, monkey_items[i,j])
    }

    for (j=1; j<=monkey_ops_count[i]; j++) {
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
  monkey_ops_count[monkey_nr] = length(ops)
  for (i in ops) {
    monkey_ops[monkey_nr,i] = ops[i]
    if (DEBUG) {
      printf("ops[%s]: %s\n", i, ops[i])
    }
  }

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

  monkey_rounds = 20

  while (monkey_rounds--) {
    printf("monkey_rounds: %s\n", monkey_rounds)

    for (i=0; i<total_monkey_nr; i++) {
      printf("monkey_nr: %s\n", i)

      while (monkey_items_count[i] > 0) {
        monkey_inspected_items[i + 1]++
        item_worry = item_dequeue(i)
        new_item_worry = alter_worry(i, item_worry)
        printf("item_worry: %s\n", item_worry)
        printf("new_item_worry: %s\n", new_item_worry)

        new_item_worry = int(new_item_worry / 3)
        printf("new_item_worry / 3: %s\n", new_item_worry)

        if (new_item_worry % monkey_div[i] == 0) {
          item_enqueue(monkey_if_true[i], new_item_worry)
        } else {
          item_enqueue(monkey_if_false[i], new_item_worry)
        }
      }
      print("-----------------------------------")
    }
  }

  asort(monkey_inspected_items, sorted_items, "@val_num_desc")

  for (i=1; i<=total_monkey_nr; i++) {
    printf("monkey_inspected_items[%s]: %s\n", i, sorted_items[i])
  }

  total = sorted_items[1] * sorted_items[2]

  printf("Total: %s\n", total)
}
