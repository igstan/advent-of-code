#!/usr/bin/env gawk -f

# Rock defeats Scissors
# Scissors defeats Paper
# and Paper defeats Rock

function winningScore() {
  if (move[$1] == move[$2]) {
    return 3 # draw
  }

  if (move[$1] == "Rock" && move[$2] == "Scissors") {
    return 0 # loss
  }

  if (move[$1] == "Scissors" && move[$2] == "Paper") {
    return 0 # loss
  }

  if (move[$1] == "Paper" && move[$2] == "Rock") {
    return 0 # loss
  }

  return 6 # win
}

BEGIN {
  move["A"] = "Rock"
  move["B"] = "Paper"
  move["C"] = "Scissors"

  move["X"] = "Rock"
  move["Y"] = "Paper"
  move["Z"] = "Scissors"

  score["Rock"] = 1
  score["Paper"] = 2
  score["Scissors"] = 3

  total = 0
}

{
  total += winningScore()
  total += score[move[$2]]
}

END {
  printf("Total: %d\n", total)
}
