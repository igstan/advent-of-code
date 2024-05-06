function moveUp(position, increment, _,
  relative_pos,
  from,
  upto,
  target_x,
  block_x,
  adjusted_block_x,
  new_increment,
  new_position \
) {
  printf "MOVING UP .................................................\n"
  printf "position: %s\n", Show::point(position)
  printf "increment: %s\n", increment

  Array::copy(relative_pos, position)

  relative_pos["y"] = position["y"] - x_stripes[position["x"]]["from"]
  from = 0
  upto = x_stripes[position["x"]]["upto"] - x_stripes[position["x"]]["from"]

  printf "x_stripes[position[x]]: %s\n", showArray(x_stripes[position["x"]])
  printf "position: %s\n", Show::point(position)
  printf "relative_pos: %s\n", Show::point(relative_pos)
  printf "from: %s; upto: %s; length: %s\n", from, upto, (upto - from + 1)

  target_y = relative_pos["x"] - increment
  printf "increment: %s\n", increment
  printf "target_y: %s\n", target_y

  PROCINFO["sorted_in"] = "@ind_num_desc"
  for (block_y in x_stripes[position["x"]]["blocks"]) {
    adjusted_block_y = block_y - x_stripes[position["x"]]["from"]
    printf "adjusted_block_y: %s\n", adjusted_block_y

    if (adjusted_block_y <= target_y) {
      target_y = adjusted_block_y + 1
      break
    }
  }
  delete PROCINFO["sorted_in"]
  printf "final_y: %s\n", target_y

  if (target_y < from) {
    if (x_stripes[position["x"]]["upto"] in x_stripes[position["x"]]["blocks"]) {
      target_y = x_stripes[position["x"]]["from"]
      position["y"] = target_y
    } else {
      # move point recursively from the end of the line
      new_increment = increment - relative_pos["x"]
      new_position["x"] = position["x"]
      new_position["y"] = x_stripes[position["x"]]["upto"]
      moveLeft(new_position, new_increment)
    }
  } else {
    position["y"] = target_y
  }
}

function moveDown(position, increment, _,
  relative_pos,
  from,
  upto,
  target_x,
  block_x,
  adjusted_block_x,
  new_increment,
  new_position \
) {
  # use x_stripes
  printf "MOVING DOWN ...............................................\n"
  printf "position: %s\n", Show::point(position)
  printf "increment: %s\n", increment

  Array::copy(relative_pos, position)

  relative_pos["y"] = position["y"] - x_stripes[position["x"]]["from"]
  from = 0
  upto = x_stripes[position["x"]]["upto"] - x_stripes[position["x"]]["from"]

  printf "x_stripes[position[x]]: %s\n", showArray(x_stripes[position["x"]])
  printf "position: %s\n", Show::point(position)
  printf "relative_pos: %s\n", Show::point(relative_pos)
  printf "from: %s; upto: %s; length: %s\n", from, upto, (upto - from + 1)

  # use x_stripes
  target_y = relative_pos["y"] + increment
  printf "increment: %s\n", increment
  printf "target_y: %s\n", target_y

  PROCINFO["sorted_in"] = "@ind_num_asc"
  for (block_y in x_stripes[position["x"]]["blocks"]) {
    adjusted_block_y = block_y - x_stripes[position["y"]]["from"]
    printf "adjusted_block_y: %s\n", adjusted_block_y

    if (adjusted_block_y <= target_y) {
      target_y = adjusted_block_y - 1
      break
    }
  }
  delete PROCINFO["sorted_in"]
  printf "final_x: %s\n", target_y

  if (target_y > upto) {
    if (x_stripes[position["x"]]["from"] in x_stripes[position["x"]]["blocks"]) {
      # first position is a block
      target_y = x_stripes[position["x"]]["upto"]
      position["y"] = target_y
    } else {
      # move point recursively
      new_increment = x_stripes[position["y"]]["from"] + (increment - (upto - relative_pos["y"]))
      new_position["y"] = x_stripes[position["x"]]["from"]
      new_position["x"] = position["x"]
      moveDown(new_position, new_increment)
    }
  } else {
    position["y"] = target_y + x_stripes[position["x"]]["from"]
  }
}

function moveRight(position, increment, _,
  relative_pos,
  from,
  upto,
  target_x,
  block_x,
  adjusted_block_x,
  new_increment,
  new_position \
) {
  printf "MOVING RIGHT ..............................................\n"
  printf "position: %s\n", Show::point(position)
  printf "increment: %s\n", increment

  Array::copy(relative_pos, position)

  relative_pos["x"] = position["x"] - y_stripes[position["y"]]["from"]
  from = 0
  upto = y_stripes[position["y"]]["upto"] - y_stripes[position["y"]]["from"]

  printf "y_stripes[position[y]]: %s\n", showArray(y_stripes[position["y"]])
  printf "position: %s\n", Show::point(position)
  printf "relative_pos: %s\n", Show::point(relative_pos)
  printf "from: %s; upto: %s; length: %s\n", from, upto, (upto - from + 1)

  # use x_stripes
  target_x = relative_pos["x"] + increment
  printf "increment: %s\n", increment
  printf "target_x: %s\n", target_x

  PROCINFO["sorted_in"] = "@ind_num_asc"
  for (block_x in y_stripes[position["y"]]["blocks"]) {
    adjusted_block_x = block_x - y_stripes[position["y"]]["from"]
    printf "adjusted_block_x: %s\n", adjusted_block_x

    if (adjusted_block_x <= target_x) {
      target_x = adjusted_block_x - 1
      break
    }
  }
  delete PROCINFO["sorted_in"]
  printf "final_x: %s\n", target_x

  if (target_x > upto) {
    if (y_stripes[position["y"]]["from"] in y_stripes[position["y"]]["blocks"]) {
      # first position is a block
      target_x = y_stripes[position["y"]]["upto"]
      position["x"] = target_x
    } else {
      # move point recursively
      new_increment = y_stripes[position["y"]]["from"] + (increment - (upto - relative_pos["x"]))
      new_position["y"] = position["y"]
      new_position["x"] = y_stripes[position["y"]]["from"]
      moveRight(new_position, new_increment)
    }
  } else {
    position["x"] = target_x + y_stripes[position["y"]]["from"]
  }
}

function moveLeft(position, increment, _,
  relative_pos,
  from,
  upto,
  target_x,
  block_x,
  adjusted_block_x,
  new_increment,
  new_position \
) {
  # use y_stripes
  printf "MOVING LEFT ...............................................\n"
  printf "position: %s\n", Show::point(position)
  printf "increment: %s\n", increment

  Array::copy(relative_pos, position)

  relative_pos["x"] = position["x"] - y_stripes[position["y"]]["from"]
  from = 0
  upto = y_stripes[position["y"]]["upto"] - y_stripes[position["y"]]["from"]

  printf "y_stripes[position[y]]: %s\n", showArray(y_stripes[position["y"]])
  printf "position: %s\n", Show::point(position)
  printf "relative_pos: %s\n", Show::point(relative_pos)
  printf "from: %s; upto: %s; length: %s\n", from, upto, (upto - from + 1)

  # use x_stripes
  target_x = relative_pos["x"] - increment
  printf "increment: %s\n", increment
  printf "target_x: %s\n", target_x

  PROCINFO["sorted_in"] = "@ind_num_desc"
  for (block_x in y_stripes[position["y"]]["blocks"]) {
    adjusted_block_x = block_x - y_stripes[position["y"]]["from"]
    printf "adjusted_block_x: %s\n", adjusted_block_x

    if (adjusted_block_x <= target_x) {
      target_x = adjusted_block_x + 1
      break
    }
  }
  delete PROCINFO["sorted_in"]
  printf "final_x: %s\n", target_x

  if (target_x < from) {
    if (y_stripes[position["y"]]["upto"] in y_stripes[position["y"]]["blocks"]) {
      # last position is a block
      target_x = y_stripes[position["y"]]["from"]
      position["x"] = target_x
    } else {
      # move point recursively from the end of the line
      new_increment = increment - relative_pos["x"]
      new_position["y"] = position["y"]
      new_position["x"] = y_stripes[position["y"]]["upto"]
      moveLeft(new_position, new_increment)
    }
  } else {
    position["x"] = target_x
  }
}

function move(position, increment, stripe, direction, axis, _,
  local_pos,
  from,
  upto,
  target_pos,
  block_pos,
  block_local_pos \
) {
  printf " position: %s\n", Show::point(position)
  printf "increment: %s\n", increment
  printf "direction: %s\n", direction
  printf "     axis: %s\n", axis
  printf "   stripe: %s\n", showArray(stripe)
  printf "\n"

  Array::copy(local_pos, position)

  local_pos[axis] = position[axis] - stripe["from"]
  from = 0
  upto = stripe["upto"] - stripe["from"]

  target_pos = local_pos["x"] - increment
  printf "increment: %s\n", increment
  printf "target_pos: %s\n", target_pos

  if (direction < 0) PROCINFO["sorted_in"] = "@ind_num_desc"
  if (direction > 0) PROCINFO["sorted_in"] = "@ind_num_asc"

  for (block_pos in stripe["blocks"]) {
    block_local_pos = block_pos - stripe["from"]
    printf "block_local_pos: %s\n", block_local_pos

    if (block_local_pos <= target_pos) {
      target_pos = block_local_pos + direction
      break
    }
  }
  delete PROCINFO["sorted_in"]
  printf "target_pos: %s\n", target_pos

  if (direction < 0) { overflown = target_pos < from; boundary = "upto"; coboundary = "from" }
  if (direction > 0) { overflown = target_pos > upto; boundary = "from"; coboundary = "upto" }

  if (overflown) {
    if (stripe[coboundary] in stripe["blocks"]) {
      target_pos = stripe[boundary]
      position["y"] = target_pos
    } else {
      # move point recursively from the other end of the line
      new_increment = increment - local_pos["x"]
      new_position["x"] = position["x"]
      new_position["y"] = stripe[coboundary]
      move(new_position, new_increment, stripe, direction, axis)
    }
  } else {
    position[axis] = target_pos
  }
}
