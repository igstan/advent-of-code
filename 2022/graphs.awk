#!/usr/bin/env gawk -f

#
# Chapter 3, Algorithms [book], Dasgupta, Papadimitriou & Vazirani
#

@include "prelude"

@namespace "graph"

function node(graph, a) {
  graph[a]
}

function edge(graph, a, b) {
  graph[a][b] = 1
  graph[b][a] = 1
}

@namespace "awk"

function appendDottedEdge(graph, src, dst) {
  dot = dot sprintf("  %s -- %s\n", src, dst)
}

function dotted(graph) {
  dot = "graph {\n"
  recursiveDFS(graph, "appendDottedEdge")
  return dot "}"
}

function explore(graph, src, visited, previsit, _, dst) {
  visited[src] = 1
  printf(" node: %s\n", src)

  for (dst in graph[src]) {
    if (!visited[dst]) {
      if (previsit) {
        @previsit(graph, src, dst)
      }

      explore(graph, dst, visited, previsit)
    }
  }
}

function recursiveDFS(graph, previsit, _, visited) {
  for (node in graph) {
    if (!visited[node]) {
      explore(graph, node, visited, previsit)
    }
  }
}

function iterativeDFS(graph, _, visited, stack, node, head, dst) {
  delete visited
  delete stack

  for (node in graph) {
    if (visited[node]) {
      continue
    }

    stack[++head] = node

    while (head > 0) {
      src = stack[head--]

      if (visited[src]) {
        continue
      }

      visited[src] = 1
      printf(" node: %s\n", src)

      for (dst in graph[src]) {
        stack[++head] = dst
      }
    }
  }
}

function iterativeBFS(graph, _, visited, queue, node, head, tail, src, dst) {
  delete visited
  delete queue

  for (node in graph) {
    queue[++tail] = node
  }

  while (head != tail) {
    src = queue[++head]

    if (visited[src]) {
      continue
    }

    visited[src] = 1
    printf(" node: %s\n", src)

    for (dst in graph[src]) {
      queue[++tail] = dst
    }
  }
}

function figure3_2(g) {
  delete g

  graph::edge(g, "A", "B")
  graph::edge(g, "A", "C")
  graph::edge(g, "A", "D")
  graph::edge(g, "B", "E")
  graph::edge(g, "B", "F")
  graph::edge(g, "C", "F")
  graph::edge(g, "D", "G")
  graph::edge(g, "D", "H")
  graph::edge(g, "E", "I")
  graph::edge(g, "E", "J")
  graph::edge(g, "G", "D")
  graph::edge(g, "G", "H")
  graph::edge(g, "K", "L")
}

function figure3_6(g) {
  delete g

  graph::edge(g, "A", "B")
  graph::edge(g, "A", "E")
  graph::edge(g, "E", "I")
  graph::edge(g, "E", "J")

  graph::node(g, "F")

  graph::edge(g, "C", "D")
  graph::edge(g, "C", "G")
  graph::edge(g, "C", "H")
  graph::edge(g, "D", "H")
  graph::edge(g, "G", "K")
  graph::edge(g, "H", "K")
  graph::edge(g, "H", "L")
}

function countConnectedComponents(graph, _, visited, stack, node, head, src, dst, ccnum) {
  delete visited
  delete stack

  for (node in graph) {
    if (visited[node]) {
      continue
    }

    ccnum++

    stack[++head] = node

    while (head > 0) {
      src = stack[head--]

      if (visited[src]) {
        continue
      }

      visited[src] = 1

      for (dst in graph[src]) {
        stack[++head] = dst
      }
    }
  }

  return ccnum
}

BEGIN {
  # figure3_2(graph)
  figure3_6(graph)

  printf("Recursive DFS:\n")
  recursiveDFS(graph)
  printf("\n")

  printf("Iterative DFS:\n")
  iterativeDFS(graph)
  printf("\n")

  printf("Iterative BFS:\n")
  iterativeBFS(graph)
  printf("\n")

  printf("Connected Components: %s\n", countConnectedComponents(graph))
  printf("\n")

  printf("%s\n", dotted(graph)) | "dot -Tpdf -ograph.pdf"
  # printf("%s\n", dotted(graph))
}
