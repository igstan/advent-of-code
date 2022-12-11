# Notes

## Day 11

It's interesting how AWK function's inability to take references as parameters
means that we have to structure the data model in a way that resemble Data-
Oriented Programming. By this I mean that instead of having array of
structures, I'm forced of having structures of arrays. This is not quite
precise since AWK doesn't have structures, but definining a bunch of global
array variables indexed by an entity ID is pretty similar to what AOP proposes.
