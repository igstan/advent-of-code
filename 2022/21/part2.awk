#!/usr/bin/env gawk -f

@include "prelude"

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
      # printArray(pending)

      if (isarray(pending[pending_p])) {
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

{
  if (match($0, /([^:]+):[[:space:]]+([0-9]+)/, groups)) {
    result = groups[1]
    number = groups[2]

    values[result] = int(number)
    graph[result][1] = 1
    delete graph[result][1]
  } else {
    match($0, /([^:]+):[[:space:]]+([^[:space:]]+)[[:space:]]+([^[:space:]]+)[[:space:]]+([^$]+)/, groups)
    result = groups[1]
    operand1 = groups[2]
    operator = groups[3]
    operand2 = groups[4]

    values[result]["op"] = operator
    values[result]["arg1"] = operand1
    values[result]["arg2"] = operand2
    graph[result][operand1] = 1
    graph[result][operand2] = 1
  }
}

function solveReverse(values, resultName, result, _) {
  if (values[resultName]["op"] == "+") {
    if (values[resultName]["arg1"] in values && "number" == typeof(values[values[resultName]["arg1"]])) {
      return result - values[values[resultName]["arg1"]]
    }

    if (values[resultName]["arg2"] in values && "number" == typeof(values[values[resultName]["arg2"]])) {
      return result - values[values[resultName]["arg2"]]
    }
  }

  if (values[resultName]["op"] == "-") {
    if (values[resultName]["arg1"] in values && "number" == typeof(values[values[resultName]["arg1"]])) {
      return values[values[resultName]["arg1"]] - result
    }

    if (values[resultName]["arg2"] in values && "number" == typeof(values[values[resultName]["arg2"]])) {
      return result + values[values[resultName]["arg2"]]
    }
  }

  if (values[resultName]["op"] == "*") {
    if (values[resultName]["arg1"] in values && "number" == typeof(values[values[resultName]["arg1"]])) {
      return result / values[values[resultName]["arg1"]]
    }

    if (values[resultName]["arg2"] in values && "number" == typeof(values[values[resultName]["arg2"]])) {
      return result / values[values[resultName]["arg2"]]
    }
  }

  if (values[resultName]["op"] == "/") {
    if (values[resultName]["arg1"] in values && "number" == typeof(values[values[resultName]["arg1"]])) {
      return values[values[resultName]["arg1"]] / result
    }

    if (values[resultName]["arg2"] in values && "number" == typeof(values[values[resultName]["arg2"]])) {
      return result * values[values[resultName]["arg2"]]
    }
  }

  printf "resultName: %s\n", resultName
}

END {
  # printf("%s\n", dotted(graph)) | "dot -Tpdf -o" FILENAME ".pdf"

  toposort(graph, sorted)

  delete values["humn"]

  for (i = 1; i <= length(sorted); i++) {
    # printf "processing %s → %s...\n", sorted[i], typeof(values[sorted[i]])
    # printf "%s: %s → %s\n", i, sorted[i], values[sorted[i]]

    if (sorted[i] == "humn" || "number" == typeof(values[sorted[i]])) {
      continue
    } else {
      skip = 0

      if (!(values[sorted[i]]["arg1"] in values) || typeof(values[values[sorted[i]]["arg1"]]) != "number") {
        pending[++pending_p] = values[sorted[i]]["arg1"]
        skip = 1
      }

      if (!(values[sorted[i]]["arg2"] in values) || typeof(values[values[sorted[i]]["arg2"]]) != "number") {
        pending[++pending_p] = values[sorted[i]]["arg2"]
        skip = 1
      }

      if (sorted[i] == "root") {
        if (values[sorted[i]]["arg1"] in values && typeof(values[values[sorted[i]]["arg1"]]) == "number") {
          mirror_value = values[values[sorted[i]]["arg1"]]
          delete values[values[sorted[i]]["arg1"]]
          values[values[sorted[i]]["arg1"]] = int(mirror_value)
        }

        if (values[sorted[i]]["arg2"] in values && typeof(values[values[sorted[i]]["arg2"]]) == "number") {
          mirror_value = values[values[sorted[i]]["arg2"]]
          delete values[values[sorted[i]]["arg2"]]
          values[values[sorted[i]]["arg2"]] = int(mirror_value)
        }

        result = mirror_value
        while (pending_p) {
          # printf "%s: %s → %s\n", pending_p, pending[pending_p], typeof(values[pending[pending_p]])

          if (pending[pending_p] == "humn") {
            printf "humn: %s\n", result
            break
          }

          result = solveReverse(values, pending[pending_p], result)
          # printf "result: %s\n", result

          pending_p--
        }

        break
      }

      if (skip) {
        # printf "skipping %s → %s...\n", sorted[i], sorted[i] in values
        continue
      }

      if (values[sorted[i]]["op"] == "+") {
        temp = values[values[sorted[i]]["arg1"]] + values[values[sorted[i]]["arg2"]]
        delete values[sorted[i]]
        values[sorted[i]] = int(temp)
        continue
      }

      if (values[sorted[i]]["op"] == "-") {
        temp = values[values[sorted[i]]["arg1"]] - values[values[sorted[i]]["arg2"]]
        delete values[sorted[i]]
        values[sorted[i]] = int(temp)
        continue
      }

      if (values[sorted[i]]["op"] == "*") {
        temp = values[values[sorted[i]]["arg1"]] * values[values[sorted[i]]["arg2"]]
        delete values[sorted[i]]
        values[sorted[i]] = int(temp)
        continue
      }

      if (values[sorted[i]]["op"] == "/") {
        temp = values[values[sorted[i]]["arg1"]] / values[values[sorted[i]]["arg2"]]
        delete values[sorted[i]]
        values[sorted[i]] = int(temp)
        continue
      }
    }
  }
}
