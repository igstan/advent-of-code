#!/usr/bin/env gawk -f

@include "array"
@include "prelude"

function swap(array, i, j, _, temp) {
  # printf "swap(i=%s, j=%s): %s - %s\n", i, j, numbers[array[i]]["num"], numbers[array[j]]["num"]
  temp = array[j]
  array[j] = array[i]
  array[i] = temp
}

function move(numbers, permute, n, _, len, nrm, new_pos, dir, i) {
  len = length(numbers)
  pos = numbers[n]["pos"]
  nrm = numbers[n]["num"]

  # eliminate cycles
  mod_nrm = nrm % (len - 1)

  if (mod_nrm < 0) {
    if (abs(mod_nrm) >= pos) {
      # move right
      steps = len - 1 + mod_nrm
      if (LOG) {
        printf "1.1 → mod_nrm=%s; steps=%s\n", mod_nrm, steps
      }

      for (i = 0; i < steps; i++) {
        numbers[permute[pos + i    ]]["pos"]++
        numbers[permute[pos + i + 1]]["pos"]--
        swap(permute, pos + i, pos + i + 1)
      }
    } else {
      # move left
      steps = abs(mod_nrm)
      if (LOG) {
        printf "1.2 → mod_nrm=%s; steps=%s\n", mod_nrm, steps
      }

      for (i = 0; i < steps; i++) {
        numbers[permute[pos - i    ]]["pos"]--
        numbers[permute[pos - i - 1]]["pos"]++
        swap(permute, pos - i, pos - i - 1)
      }
    }
  } else {
    if (mod_nrm >= (len - 1 - pos)) { # wraps on the right
      # move left
      steps = (len - 1 - mod_nrm) % (len - 1)
      if (LOG) {
        printf "2.1 → mod_nrm=%s; steps=%s\n", mod_nrm, steps
      }

      for (i = 0; i < steps; i++) {
        numbers[permute[pos - i    ]]["pos"]--
        numbers[permute[pos - i - 1]]["pos"]++
        swap(permute, pos - i, pos - i - 1)
      }
    } else {
      # move right
      steps = abs(mod_nrm) # useless `abs`, it's just to detect duplication
      if (LOG) {
        printf "2.2 → mod_nrm=%s; steps=%s\n", mod_nrm, steps
      }

      for (i = 0; i < steps; i++) {
        numbers[permute[pos + i    ]]["pos"]++
        numbers[permute[pos + i + 1]]["pos"]--
        swap(permute, pos + i, pos + i + 1)
      }
    }
  }
}

function display(_, i) {
  # printf "permute: %s\n", Array::show(permute)
  # for (i = 0; i < NR; i++) {
  #   printf "%02s ", i
  # }
  # printf "\n"
  for (i = 0; i < NR; i++) {
    printf "%s ", numbers[permute[i]]["num"]
  }
  printf "\n"
}

{
  ix = NR - 1
  numbers[ix]["num"] = int($1) * 811589153
  numbers[ix]["pos"] = int(ix)
  permute[ix] = ix

  if (int($1) == 0) {
    zero = ix
  }
}

END {
  if (LOG) display()

  for (n = 0; n < 10; n++) {
    for (i = 0; i < NR; i++) {
      move(numbers, permute, i)
      if (LOG) display()
    }
  }

  _1000th = numbers[ permute[(numbers[zero]["pos"] + 1000) % NR] ]["num"]
  _2000th = numbers[ permute[(numbers[zero]["pos"] + 2000) % NR] ]["num"]
  _3000th = numbers[ permute[(numbers[zero]["pos"] + 3000) % NR] ]["num"]

  printf "\n"
  printf "Sum: %s + %s + %s = %s\n", _1000th, _2000th, _3000th, _1000th + _2000th + _3000th
}
