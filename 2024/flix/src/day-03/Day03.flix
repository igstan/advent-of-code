mod Day03 {
  pub eff RegexError {
    def raise(e: String): Void
  }

  def regex(s: String): Regex \ RegexError =
    match String.toRegex(s) {
      case Err(message) => RegexError.raise(message)
      case Ok(regex) => regex
    }

  pub def part1(path: String): Unit \ IO = {
    def evaluate(line: String): Int32 \ RegexError = {
      let re = regex("mul\\([0-9]{1,3},[0-9]{1,3}\\)");
      line
        |> Regex.submatches({ substr = re })
        |> List.map(instr -> {
            Regex.submatches({ substr = regex("[0-9]{1,3}") }, instr)
              |> List.filterMap(Int32.fromString)
              |> List.reduceLeft((a, b) -> a * b)
              |> Option.getWithDefault(0)
          })
        |> List.sum
    };

    match Files.readLines("src/day-03/${path}") {
      case Err(ioerror) => println("error reading file: ${ioerror}")
      case Ok(lines) =>
        run {

          lines
            |> List.map(evaluate)
            |> List.sum
            |> answer -> println("answer: ${answer}")

        } with RegexError {
          def raise(e, _continuation) =
            println("error: invalid regex ${e}")
        }
    }
  }

  pub def part2(path: String): Unit \ IO = {
    def mul(instr: String): Int32 \ RegexError =
      Regex.submatches({ substr = regex("[0-9]{1,3}") }, instr)
        |> List.filterMap(Int32.fromString)
        |> List.reduceLeft((a, b) -> a * b)
        |> Option.getWithDefault(0);

    def evaluate(globalState: { evaluating = Bool, result = Int32 }, line: String) = {
      let instrRegex = regex("mul\\([0-9]{1,3},[0-9]{1,3}\\)|do\\(\\)|don't\\(\\)");
      let exprs = line |> Regex.submatches({ substr = instrRegex });
      (globalState, exprs) ||> List.foldLeft((lineState, instr) -> {
        let { result, evaluating } = lineState;
        match instr {
          case "do()"              => { result = result,              evaluating = true }
          case "don't()"           => { result = result,              evaluating = false }
          case _ if not evaluating => { result = result,              evaluating = false }
          case _                   => { result = result + mul(instr), evaluating = true }
        }
      })
    };

    match Files.readLines("src/day-03/${path}") {
      case Err(ioerror) => println("error reading file: ${ioerror}")
      case Ok(lines) =>
        run {

          ({ result = 0, evaluating = true }, lines)
            ||> List.foldLeft(evaluate)
            |> match { result | _ } -> println("answer: ${result}")

        } with RegexError {
          def raise(e, _continuation) =
            println("error: invalid regex ${e}")
        }
    }
  }
}
