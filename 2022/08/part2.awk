#!/usr/bin/env gawk -f

# Built-in functions return 1-based arrays:
#
# BEGIN {
#   n = split("foo", parts, //)
#   for (i=1; i<=n; i++) {
#     printf("%s", parts[i])
#   }
#   print("")
# }

function display_grid(array, N, M) {
  for (i=1; i<=N; i++) {
    for (j=1; j<=M; j++) {
      printf("%d ", array[i,j])
    }
    print("")
  }
}

{
  rows[NR] = $0 # accumulate rows
}

END {
  # for (i=1; i<=NR; i++) {
  #   for (j=1; j<=length; j++) {
  #     printf("%d ", substr(rows[i], j, 1))
  #   }
  #   print("")
  # }
  # print("-------------")

  # LEFT & TOP VISIBILITY
  for (i=1; i<=NR; i++) {
    for (j=1; j<=length; j++) {
      # current tree height
      curr_h = 1 * substr(rows[i], j, 1)

      # HORIZONTAL BLOCKING
      old_candidate = ""
      for (hi=9; hi>=curr_h; hi--) {
        candidate = h_window[i,hi]

        # printf("h_window[%d,%d]: '%s'\n", i, hi, candidate)

        if (candidate != "") {
          if (old_candidate == "") {
            left_distance[i,j] = j - candidate
            old_candidate = candidate
          } else {
            if (candidate > old_candidate) {
              left_distance[i,j] = j - candidate
              old_candidate = candidate
            }
          }
        }
      }
      if (left_distance[i,j] == "") {
        left_distance[i,j] = j - 1
      }

      # VERTICAL BLOCKING
      old_candidate = ""
      for (vi=9; vi>=curr_h; vi--) {
        candidate = v_window[j,vi]

        if (candidate != "") {
          if (old_candidate == "") {
            top_distance[i,j] = i - candidate
            old_candidate = candidate
          } else {
            if (candidate > old_candidate) {
              top_distance[i,j] = i - candidate
              old_candidate = candidate
            }
          }
        }
      }
      if (top_distance[i,j] == "") {
        top_distance[i,j] = i - 1
      }

      h_window[i,curr_h] = j
      v_window[j,curr_h] = i
    }
  }

  delete h_window
  delete v_window
  # BOTTOM & RIGHT VISIBILITY
  for (i=NR; i>=1; i--) {
    for (j=length; j>=1; j--) {
      # current tree height
      curr_h = 1 * substr(rows[i], j, 1)

      # HORIZONTAL BLOCKING
      old_candidate = ""
      for (hi=9; hi>=curr_h; hi--) {
        candidate = h_window[i,hi]

        if (candidate != "") {
          if (old_candidate == "") {
            right_distance[i,j] = candidate - j
            old_candidate = candidate
          } else {
            if (candidate < old_candidate) {
              right_distance[i,j] = candidate - j
              old_candidate = candidate
            }
          }
        }
      }
      if (right_distance[i,j] == "") {
        right_distance[i,j] = length - j
      }

      # VERTICAL BLOCKING
      old_candidate = ""
      for (vi=9; vi>=curr_h; vi--) {
        candidate = v_window[j,vi]

        if (candidate != "") {
          if (old_candidate == "") {
            bottom_distance[i,j] = candidate - i
            old_candidate = candidate
          } else {
            if (candidate < old_candidate) {
              bottom_distance[i,j] = candidate - i
              old_candidate = candidate
            }
          }
        }
      }
      if (bottom_distance[i,j] == "") {
        bottom_distance[i,j] = length - i
      }

      h_window[i,curr_h] = j
      v_window[j,curr_h] = i
    }
  }

  # print("")
  # print("LEFT DISTANCE")
  # print("=============")
  # display_grid(left_distance, NR, length)

  # print("")
  # print("TOP DISTANCE")
  # print("============")
  # display_grid(top_distance, NR, length)

  # print("")
  # print("RIGHT DISTANCE")
  # print("==============")
  # display_grid(right_distance, NR, length)

  # print("")
  # print("BOTTOM DISTANCE")
  # print("===============")
  # display_grid(bottom_distance, NR, length)

  scenic_score = 0
  final_i = 0
  final_j = 0
  for (i=1; i<=NR; i++) {
    for (j=1; j<=length; j++) {
      potential = left_distance[i,j] * top_distance[i,j] * right_distance[i,j] * bottom_distance[i,j]

      if (scenic_score < potential) {
        scenic_score = potential
        final_i = i
        final_j = j
      }
    }
  }

  printf("Max scenic score: %d at (%d,%d)\n", scenic_score, final_i, final_j)
}
