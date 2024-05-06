#!/usr/bin/env gawk -f

@include "prelude"
@include "array"

END {
  n = split($0, nums, /,/)

  printf "nums: %s\n", Array::show(nums)

  # starting with each index
  for (j = 0; j < n; j++) {
    # printf "resetting stack...\n"
    # delete stack # reset stack
    # stack_p = 0
    m = -1

    # for each possible length
    for (i = 1; i <= n - j; i++) {
      # if the end index is within bounds
      # if (i + j <= n) {
        printf "n: %s\n", nums[i + j]

        m = m == -1 ? nums[i + j] : min(m, nums[i + j])
        # printf "min %s\n", m

        sum += m
        # iterate from start index until end index
        # for (k = j + 1; k <= i + j; k++) {
        #   printf "%s", nums[k]
        # }
        # printf "\n"
      # }
    }
  }

  printf "sum: %s\n", sum
}

# 3,1,2,4

# 1 → 3       ; 1     ; 2   ; 4
# 2 → 3,1     ; 1,2   ; 2,4
# 3 → 3,1,2   ; 1,2,4
# 4 → 3,1,2,4



  1
3 3 2 4

      4
    2 2
3 1 1 1
