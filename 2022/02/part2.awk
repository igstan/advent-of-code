#!/usr/bin/env gawk -f

# Rock defeats Scissors
# Scissors defeats Paper
# and Paper defeats Rock

function roundScore() {
  if (move[$2] == "draw") {
    return score[move[$1]] + 3
  }

  if (move[$1] == "Rock") {
    if (move[$2] == "lose") {
      return score["Scissors"] + 0
    }
    if (move[$2] == "win") {
      return score["Paper"] + 6
    }
  }

  if (move[$1] == "Paper") {
    if (move[$2] == "lose") {
      return score["Rock"] + 0
    }
    if (move[$2] == "win") {
      return score["Scissors"] + 6
    }
  }

  if (move[$1] == "Scissors") {
    if (move[$2] == "lose") {
      return score["Paper"] + 0
    }
    if (move[$2] == "win") {
      return score["Rock"] + 6
    }
  }
}

BEGIN {
  move["A"] = "Rock"
  move["B"] = "Paper"
  move["C"] = "Scissors"

  move["X"] = "lose"
  move["Y"] = "draw"
  move["Z"] = "win"

  score["Rock"] = 1
  score["Paper"] = 2
  score["Scissors"] = 3

  total = 0
}

{
  total += roundScore()
}

END {
  printf("Total: %d\n", total)
}
