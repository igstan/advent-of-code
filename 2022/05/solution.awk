#!/usr/bin/env gawk -f

# BEGIN {
#   print(substr("FOO", 1, 2))
# }

NR == 1 {
  total_stacks = (length($0) + 1) / 4
}

stack_read == 0 && /^\[/ {
  for (i = 1; i <= total_stacks; i++) {
    c = substr($0, (i-1)*4+2, 1)
    if (c != " ") {
      stacks[i] = stacks[i] c
    }
  }
}

/^$/ {
  stack_read = 1
}

function part1() {
  match($0, /move ([0-9]+) from ([0-9]+) to ([0-9]+)/, groups)
  count = groups[1]
  src_stack = groups[2]
  dst_stack = groups[3]

  for (i=1; i<=count; i++) {
    stacks[dst_stack] = substr(stacks[src_stack], 1, 1) stacks[dst_stack]
    stacks[src_stack] = substr(stacks[src_stack], 2)
  }
}

function part2() {
  match($0, /move ([0-9]+) from ([0-9]+) to ([0-9]+)/, groups)
  count = groups[1]
  src_stack = groups[2]
  dst_stack = groups[3]
  stacks[dst_stack] = substr(stacks[src_stack], 1, count) stacks[dst_stack]
  stacks[src_stack] = substr(stacks[src_stack], count + 1)
}

/move/ {
  # for (i = 1; i <= total_stacks; i++) {
  #   printf("%d: %s\n", i, stacks[i])
  # }

  # part1()
  part2()
}

END {
  # for (i = 1; i <= total_stacks; i++) {
  #   printf("%d: %s\n", i, stacks[i])
  # }

  for (i = 1; i <= total_stacks; i++) {
    printf("%s", substr(stacks[i], 1, 1))
  }
  print("")
}
