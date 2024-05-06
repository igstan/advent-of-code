function move(position, increment, stripe, axis, direction, _,
  from,
  upto,
  local_pos,
  target_local_pos,
  block_pos,
  block_local_pos,
  new_increment,
  coaxis \
) {
  # printf " position: %s\n", Show::point(position)
  # printf "increment: %s\n", increment
  # printf "direction: %s\n", direction
  # printf "     axis: %s\n", axis
  # printf "   stripe: %s\n", showArray(stripe)
  # printf "\n\n\n"

  if (increment == 0) {
    # printf "increment was zero; returning\n"
    return
  }

  Array::copy(local_pos, position)

  from = 0
  upto = stripe["upto"] - stripe["from"]
  # printf "from: %s; upto: %s\n", from, upto
  local_pos[axis] = position[axis] - stripe["from"]

  target_local_pos = local_pos[axis] + increment * direction # add/subtract
  # printf "local_pos: %s\n", Show::point(local_pos)
  # printf "increment: %s\n", increment
  # printf "target_local_pos: %s\n", target_local_pos

  if (direction < 0) PROCINFO["sorted_in"] = "@ind_num_desc"
  if (direction > 0) PROCINFO["sorted_in"] = "@ind_num_asc"

  for (block_pos in stripe["blocks"]) {
    block_local_pos = block_pos - stripe["from"]
    # printf "block_local_pos: %s\n", block_local_pos

    if (direction < 0 && block_local_pos > local_pos[axis]) {
      continue
    }

    if (direction > 0 && block_local_pos < local_pos[axis]) {
      continue
    }

    # printf "block_local_pos: %s\n", block_local_pos

    if (direction < 0) {
      if (block_local_pos >= target_local_pos) {
        # printf "XXX\n"
        target_local_pos = block_local_pos - direction
        break
      }
    } else {
      if (block_local_pos <= target_local_pos) {
        # printf "XXX\n"
        target_local_pos = block_local_pos - direction
        break
      }
    }
  }
  delete PROCINFO["sorted_in"]
  # printf "target_local_pos after blocking: %s\n", target_local_pos

  if (direction < 0) {
    overflown = target_local_pos < from
    boundary = "from";
    coboundary = "upto"
  }
  if (direction > 0) {
    overflown = target_local_pos > upto
    boundary = "upto";
    coboundary = "from"
  }

  if (overflown) {
    # printf "overflown A: %s\n", upto
    if (stripe[coboundary] in stripe["blocks"]) {
      # printf "overflown B\n"
      position[axis] = stripe[boundary]
    } else {
      # printf "overflown C\n"
      # move point recursively from the other end of the line
      if (direction < 0) {
        new_increment = increment - 1 - local_pos[axis]
        # printf "new_increment=%s; upto=%s; local_pos[axis]=%s\n", new_increment, upto, local_pos[axis]
      } else {
        new_increment = increment - 1 - (upto - local_pos[axis])
        # printf "new_increment: %s %s %s\n", new_increment, upto, local_pos[axis]
      }
      if (new_increment == 0) {
        # printf "new_increment was zero; returning\n"
        return
      }

      position[axis] = stripe[coboundary]
      move(position, new_increment, stripe, axis, direction)
    }
  } else {
    # printf "not overflown\n"
    position[axis] = stripe["from"] + target_local_pos
  }
}
