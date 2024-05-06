@namespace "Graph"

function edge(graph, a, b) {
  graph[a][b] = 1
  graph[b][a] = 1
}

function dotted(graph, rates, _, dot, n1, n2, visited) {
  dot = \
    "graph {\n" \
    "  node [ shape = circle ]\n\n" \
    "  AA [\n" \
    "    fillcolor = \"#e0e0e0\"\n" \
    "    style     = \"filled\"\n" \
    "    fontcolor = \"#444444\"\n" \
    "  ]\n\n"

  for (n1 in graph) {
    dot = dot sprintf("  %s [label=\"%s [%s]\"]\n", n1, n1, rates[n1])

    for (n2 in graph[n1]) {
      if (visited[n2][n1]) continue
      visited[n1][n2] = 1
      dot = dot sprintf("  %s -- %s\n", n1, n2)
    }
  }

  return dot "}"
}
