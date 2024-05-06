#!/usr/bin/env gawk -f

@include "prelude"

@namespace "Digraph"

function edge(graph, a, b, weight) {
  graph[a][b] = weight
}

function dotted(graph, _, dot, n1, n2) {
  dot = \
    "digraph {\n" \
    "  rankdir = LR\n" \
    "\n" \
    "  # graph [\n" \
    "  #   splines = ortho\n" \
    "  # ]\n" \
    "\n" \
    "  node [\n" \
    "    shape = circle\n" \
    "  ]\n" \
    "\n" \
    "  edge [\n" \
    "    # constraint = false\n" \
    "    arrowsize = 0.3\n" \
    "    fontsize = 7\n" \
    "  ]\n\n"

  for (n1 in graph) {
    for (n2 in graph[n1]) {
      dot = dot sprintf("  %s -> %s [label=%s]\n", n1, n2, graph[n1][n2])
    }
  }

  return dot "}"
}

@namespace "awk"

BEGIN {
  Digraph::edge(graph, "s", "a", 20)
  Digraph::edge(graph, "s", "b", 31)
  Digraph::edge(graph, "b", "a", 2)
  Digraph::edge(graph, "b", "c", 30)
  Digraph::edge(graph, "a", "c", 21)
  Digraph::edge(graph, "c", "t", 75)
  Digraph::edge(graph, "t", "c", 10)

  printf "%s\n", Digraph::dotted(graph) | "dot -Tpdf -odigraph.pdf"
  printf "%s\n", Digraph::dotted(graph) > "digraph.dot"
}
