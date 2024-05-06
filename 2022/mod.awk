@namespace "Mod"

function add(a, b, m) {
  return ((a % m) + (b % m)) % m
}

function sub(a, b, m) {
  return ((a % m) - (b % m)) % m
}

function mul(a, b, m) {
  return ((a % m) * (b % m)) % m
}
