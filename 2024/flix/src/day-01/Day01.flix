mod Day01 {
  pub def part1Bis(): Unit \ IO =
    Files.readLines("src/day-01/input")
      |> Result.map( lines ->
          lines
            |> List.filterMap(pairFromLine)
            |> List.unzip
            ||> (l, r) -> (List.sort(l), List.sort(r))
            ||> List.zipWith((a, b) -> Int32.abs(a - b))
            |> List.sum
            |> total -> "total: ${total}"
        )
      |> Result.mapErr(e -> "error reading file: ${e}")
      |> Result.forEach(println)

  pub def part1(): Unit \ IO =
    match Files.readLines("src/day-01/input") {
      case Err(a) => println("error reading file: ${a}")
      case Ok(lines) =>
        lines
          |> List.filterMap(pairFromLine)
          |> List.unzip
          ||> (l, r) -> (List.sort(l), List.sort(r))
          ||> List.zipWith((a, b) -> Int32.abs(a - b))
          |> List.sum
          |> total -> println("total: ${total}")
    }

  def pairFromLine(line: String): Option[(Int32, Int32)] =
    let ints = String.split({ regex = "\\s+" }, line)
      |> List.filterMap(Int32.fromString);
    match ints {
      case a :: b :: Nil => Some((a, b))
      case _ => None
    }

  pub def part2(): Unit \ IO =
    match Files.readLines("src/day-01/input") {
      case Err(a) => println("error reading file: ${a}")
      case Ok(lines) =>
        let (left, right) = lines
          |> List.filterMap(pairFromLine)
          |> List.unzip;

        let occurrences = (Map.empty(), right)
          ||> List.foldLeft((occ, r) -> Map.insert(r, 1 + Map.getWithDefault(r, 0, occ), occ));

        let total = (0, left)
          ||> List.foldLeft((sum, l) -> sum + l * Map.getWithDefault(l, 0, occurrences));

        println("total: ${total}")
    }
}
