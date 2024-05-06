# Notes

## Day 12

How to generate a rudimentary execution profile with `gawk`:

  1. Run `gawk` with `--profile[=filename]`
  2. Send signal `USR1` to the runnig program:

```bash
$ kill -USR1 $( ps | grep -e 'gawk' | grep -e '--profile' | awk '{print $1}' )
```

A snapshot of the execution will be saved in **awkprof.out**, by default.

## Day 13

The inability to assign an array reference really sucks...

```sh
$ gawk 'BEGIN { a[1] = 2; b[3] = a }'
gawk: cmd. line:1: fatal: attempt to use array `a' in a scalar context
```

The workaround would be this:

```awk
function assign(a) {
  a[1] = 2
}

BEGIN {
  assign(b[3])
}
```

Other than the more obvious, assuming it's possible/desirable:

```
b[3][1] = 2
```

Weird inversion. It reminds me somewhat of continuation-passing style. Let's
call it _continuation-passing assignment_.

(Day 15): Another way of putting this is that the only way to alias references
(is via function arguments. This means that the scope of an alias is very short?
What other implications are there because of this?

## Empty Arrays / How to Force Array Type on Variable

If result is undefined, the following will just create an empty `result` array.

```
$ gawk 'BEGIN { delete result; print typeof(result) }'
array
$ gawk 'BEGIN { print typeof(result) }'
untyped
```

`asort` doesn't seem able to sort true array of arrays. As a workaround, I've
used `asorti` to obtain the sorted keys, but using the comparison on values and
then iterate over the sorted keys in order to access the values in sorted order.

First day where I've used namespaces too.

## Day 14

Interestingly, I think that awk's support for associative arrays, hashmaps
basically has helped a lot. I don't have to resize arrays, I can just assign
new numeric indexes.

## Day 20 — 2022-12-28 23:01:05

I don't think one can build linked-lists in AWK without copying arrays, and
that's because it's impossible to store references. Every r-value has to be
a scalar.
