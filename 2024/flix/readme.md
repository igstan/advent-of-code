# Advent of Code — 2024

[Advent of Code 2024](https://adventofcode.com/2024/) solutions written in the
programming language [Flix](https://flix.dev/).

## Observations

### Nice things in Flix

Overall, quite a pleasant language and the VSCode experience is stellar given
how young this language is.

---

As opposed to Scala, inner functions don't require type annotations:

```flix
def solveLine(numLine: List[Int32]): Bool =
  def sameSign(list) =
    list |> List.map(Int32.signum) |> List.distinct |> List.size == 1;
  // ...
```

`sameSign` declares no types in its signature.

### Ugly things in Flix

Due to HM type inference, if there's a type error somewhere in the code, we
can't see the easily-inferable types from other parts of the code (in VSCode).
It's all or nothing due to HM type inference.

---

No readline history in REPL.

---

Just as in SML/NJ, the error messages kinda suck...

---

Errors for name shadowing are annoying as fuck...

### `exists` and `forall` on `Iterator`

Could/should these exist?

### Module Shadowing?

Could I somehow shadow built-in modules, such as `List`, with my own
definitions? Similar to this SML code:

```sml
structure List =
  struct
    open List (* ← this is the List in Basis *)
    (* my own definitions *)
  end
```
