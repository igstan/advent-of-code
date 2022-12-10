#!/usr/bin/env gawk -f

# command
/^\$/ {
  cmd = $2
  dir = $3

  if (cmd == "cd") {
    if (dir == "/") {
      stack_pointer = 1
      stack[stack_pointer] = ""
    } else if (dir == "..") {
      stack_pointer -= 1
    } else {
      stack_pointer += 1
      stack[stack_pointer] = dir
    }
  }
}

# file size
/[0-9]+/ {
  size = $1
  file = $2

  cwd = ""
  for (i = 1; i <= stack_pointer; i++) {
    cwd = cwd sprintf("%s/", stack[i])
    dirs[cwd] += size
  }
}

END {
  for (dir in dirs) {
    # printf("%s -> %s\n", dir, dirs[dir])
    if (dirs[dir] <= 100000) {
      total += dirs[dir]
    }
  }

  printf("Total: %s\n", total)

  unused_space = 70000000 - dirs["/"]
  still_needed = 30000000 - unused_space

  printf("Still needed: %d\n", still_needed)

  n = asort(dirs, sorted_sizes)

  for (i=1; i<=n; i++) {
    printf("%d: %d\n", i, sorted_sizes[i])

    if (sorted_sizes[i] >= still_needed) {
      printf("Delete: %s\n", sorted_sizes[i])
    }
  }
}
