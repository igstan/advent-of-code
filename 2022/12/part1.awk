#!/usr/bin/env gawk -f

@include "prelude"

{
  WIDTH = split($0, row, //)
  for (i = 1; i <= WIDTH; i++) {
    grid[NR][i] = row[i]

    if (row[i] == "S") {
      start["x"] = i
      start["y"] = NR
    }
  }
}

function canClimb(src, dst, LOCAL, src_h, dst_h, src_char, dst_char) {
  src_char = grid[src["y"]][src["x"]]
  dst_char = grid[dst["y"]][dst["x"]]
  src_char = src_char == "S" ? "a" : src_char
  dst_char = dst_char == "E" ? "z" : dst_char
  src_h = ord(src_char)
  dst_h = ord(dst_char)
  return (dst_h - src_h) < 2
}

function edges(src, result, _, i, x, y, dst) {
  delete result

  x = src["x"]
  y = src["y"]

  # left
  if (x > 1) {
    point(dst, x - 1, y)

    if (canClimb(src, dst)) {
      point(result[++i], x - 1, y)
    }
  }

  # up
  if (y > 1) {
    point(dst, x, y - 1)

    if (canClimb(src, dst)) {
      point(result[++i], x, y - 1)
    }
  }

  # right
  if (x < WIDTH) {
    point(dst, x + 1, y)

    if (canClimb(src, dst)) {
      point(result[++i], x + 1, y)
    }
  }

  # down
  if (y < HEIGHT) {
    point(dst, x, y + 1)

    if (canClimb(src, dst)) {
      point(result[++i], x, y + 1)
    }
  }

  return i
}

function enqueue(queue, point, _, tail) {
  tail = ++queue["tail"]
  queue[tail]["x"] = point["x"]
  queue[tail]["y"] = point["y"]
}

function dequeue(queue, point, _, head) {
  head = ++queue["head"]
  point["x"] = queue[head]["x"]
  point["y"] = queue[head]["y"]
  delete queue[head - 1]
}

function isEmpty(queue) {
  return queue["head"] == queue["tail"]
}

function bfs(start, _, distance, queue, src, dst, src_key, dst_key) {
  delete distance
  delete queue

  enqueue(queue, start)

  while (!isEmpty(queue)) {
    dequeue(queue, src)
    src_key = src["x"] SUBSEP src["y"]
    edges(src, neibs)

    for (dst in neibs) {
      dst_key = neibs[dst]["x"] SUBSEP neibs[dst]["y"]

      if (dst_key in distance) {
        continue
      }

      enqueue(queue, neibs[dst])
      distance[dst_key] = distance[src_key] + 1

      if (grid[neibs[dst]["y"]][neibs[dst]["x"]] == "E") {
        return distance[dst_key]
      }
    }
  }
}

END {
  HEIGHT = NR

  # for (y = 1; y <= HEIGHT; y++) {
  #   for (x = 1; x <= WIDTH; x++) {
  #     printf "%s", grid[y][x]
  #     point(p, x, y)
  #     edges(p, result)
  #     printArray(result)
  #     break
  #   }
  #   printf "\n"
  #   break
  # }

  printf "Steps: %s\n", bfs(start)
}
