#!/usr/bin/env gawk -f

@include "prelude"

@namespace "Graph"

function reverse(array, result, _) {
  awk::asort(array, result, "@ind_num_desc")
}

function dotted(graph, _, result, n1, n2) {
  result = "digraph {\n"

  for (n1 in graph) {
    for (n2 in graph[n1]) {
      result = result sprintf("  %s -> %s\n", n1, n2)
    }
  }

  result = result "}"
  return result
}

function toposort(graph, result, _, visited, pending, pending_p, result_p, node, child) {
  delete result
  delete visited
  delete pending

  for (node in graph) {
    pending[++pending_p] = node

    while (pending_p) {
      # awk::printArray(pending)

      if (awk::isarray(pending[pending_p])) {
        result[++result_p] = pending[pending_p]["done"]
        delete pending[pending_p--]
        continue
      }

      node = pending[pending_p]
      delete pending[pending_p--]

      if (node in visited) {
        continue
      }

      delete pending[++pending_p]
      pending[pending_p]["done"] = node

      visited[node] = 1

      for (child in graph[node]) {
        pending[++pending_p] = child
      }
    }
  }
}

@namespace "awk"

BEGIN {
  # for (i = 1; i <= 10; i++) {
  #   arr[i] = sprintf("i-%s", i)
  # }

  # for (i = 1; i <= 10; i++) {
  #   printf "%s: %s\n", i, arr[i]
  # }

  # Graph::reverse(arr)

  # for (i = 1; i <= 10; i++) {
  #   printf "%s: %s\n", i, arr[i]
  # }

  # graph["A"]["B"] = 1
  # graph["A"]["C"] = 1
  # graph["B"]["D"] = 1
  # graph["D"]["E"] = 1
  # graph["C"]["D"] = 1
  # graph["D"]["Z"] = 1
  # graph["Z"]["E"] = 1

  graph[0][1] = 1
  graph[0][2] = 1
  graph[0][5] = 1
  graph[1][4] = 1
  graph[2][1] = 1; delete graph[2][1] # force array element
  graph[3][2] = 1
  graph[3][4] = 1
  graph[3][5] = 1
  graph[3][6] = 1
  graph[4][1] = 1; delete graph[4][1] # force array element
  graph[5][2] = 1
  graph[6][0] = 1
  graph[6][4] = 1

  printf("%s\n", Graph::dotted(graph)) | "dot -Tpdf -otoposort.pdf"

  Graph::toposort(graph, result)

  for (i = 1; i <= length(result); i++) {
    printf "%s: %s\n", i, result[i]
  }
}
