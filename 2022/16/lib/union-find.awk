@namespace "UnionFind"

function empty(set) {
  delete set
}

function one(set, a) {
  set[a] = a
}

function union(set, a, b, _, ca, cb) {
  ca = find(set, a)
  cb = find(set, b)
  set[ca ? ca : a] = cb ? cb : b
}

function connected(set, a, b) {
  return find(set, a) == find(set, b)
}

function find(set, a, _, ca) {
  if (a in set) {
    ca = set[a]
    return ca == a ? a : find(set, ca)
  } else {
    set[a] = a
    return a
  }
}
