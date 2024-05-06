#!/usr/bin/env gawk -f

# Discussions:
#
# https://www.reddit.com/r/adventofcode/comments/zo21au/2022_day_16_approaches_and_pitfalls_discussion/

@include "array"
@include "prelude"
@include "union-find"

@namespace "Graph"

function empty(graph) {
  delete graph
}

function edge(graph, a, b, weight) {
  graph[a][b] = weight
  graph[b][a] = weight
}

function byWeight(k1, v1, k2, v2) {
  return v2["weight"] - v1["weight"]
}

function kruskal(graph, _, uf, edges, src, dst, edges_p, i) {
  UnionFind::empty(uf)
  Array::empty(edges)

  for (src in graph) {
    UnionFind::one(uf, src)

    for (dst in graph[src]) {
      edges_p++
      edges[edges_p]["src"] = src
      edges[edges_p]["dst"] = dst
      edges[edges_p]["weight"] = graph[src][dst]
    }
  }

  awk::asort(edges, edges, "Graph::byWeight")

  for (i = 1; i <= edges_p; i++) {
    printf "edge: %s\n", edges[i]["weight"]
    src = edges[i]["src"]
    dst = edges[i]["dst"]

    if (!UnionFind::connected(uf, src, dst)) {
      UnionFind::union(uf, src, dst)
      discovered++
      sum += edges[i]["weight"]
    }
  }

  printf "discovered: %s\n", discovered

  # awk::printArray(edges)
  printf "Sum: %s\n", sum
}

@namespace "awk"

BEGIN {
  Graph::empty(graph)
}

{
  match($0, /Valve ([A-Z]{2}) has flow rate=([^;]+); tunnels? leads? to valves? ([^$]+)/, groups)
  split(groups[3], leads, /, /)

  valve = groups[1]
  rate = int(groups[2])
  rates[valve] = rate

  for (k in leads) {
    Graph::edge(graph, valve, leads[k], rate)
  }
}

END {
  # printArray(graph)

  Graph::kruskal(graph)

  # printf "%s\n", Graph::dotted(graph, rates) | "dot -Tpdf -ograph.pdf"
  # printf "%s\n", Graph::dotted(graph, rates) > "graph.dot"
}
