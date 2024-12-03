mod Day02 {
  def solveLine(numLine: List[Int32]): Bool =
    def sameSign(list) =
      list |> List.map(Int32.signum) |> List.distinct |> List.size == 1;

    def withinRange(min, max) =
      List.forAll(n -> Int32.abs(n) >= min and Int32.abs(n) <= max);

    let v = ((List.empty(), None, None), numLine) ||> List.foldLeft((acc, b) ->
      match acc {
        case (result, _, None)    => (result,            None,    Some(b))
        case (result, _, Some(a)) => ((a - b) :: result, Some(a), Some(b))
      }
    );

    let result = match v {
      case (list, Some(a), Some(b)) => List.reverse(a - b :: list)
      case (list, _, _)             => List.reverse(list)
    };

    withinRange(1, 3, result) and sameSign(result)

  pub def part1(path: String): Unit \ IO =
    match Files.readLines("src/day-02/${path}") {
      case Err(a) => println("error reading file: ${a}")
      case Ok(lines) =>
        let result = lines
          |> List.map(String.words >> List.filterMap(Int32.fromString))
          |> List.map(solveLine)
          |> List.count(identity);
        println("result: ${result}")
    }

  pub def part2(path: String): Unit \ IO =
    match Files.readLines("src/day-02/${path}") {
      case Err(a) => println("error reading file: ${a}")
      case Ok(lines) =>
        let result = lines
          |> List.map(String.words >> List.filterMap(Int32.fromString))
          |> List.count(line ->
            if (solveLine(line)) {
              true
            } else {
              // Idea copied from here:
              // https://www.reddit.com/r/adventofcode/comments/1h58vl2/comment/m046b41/
              List.subsequences(line)
                |> List.filter(a -> List.size(a) == List.size(line) - 1)
                |> List.exists(solveLine)
            }
          );
        println("result: ${result}")
    }

  pub def part2DP(path: String): Unit \ IO =
    ??? // TODO: use dynamic programming
}
