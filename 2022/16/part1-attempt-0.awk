#!/usr/bin/env gawk -f

@include "prelude"
@include "graph"

{
  match($0, /Valve ([A-Z]{2}) has flow rate=([^;]+); tunnels? leads? to valves? ([^$]+)/, groups)
  split(groups[3], leads, /, /)

  valve = groups[1]
  rate = groups[2]
  rates[valve] = rate

  for (k in leads) {
    Graph::edge(graph, valve, leads[k])
  }
}

END {
  # printArray(graph)
  printf "%s\n", Graph::dotted(graph, rates) | "dot -Tpdf -ograph.pdf"
  printf "%s\n", Graph::dotted(graph, rates) > "graph.dot"
}
