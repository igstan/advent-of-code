#!/usr/bin/env gawk -f

# Discussions:
#
# https://www.reddit.com/r/adventofcode/comments/zpy5rm/2022_day_19_what_are_your_insights_and/

@include "prelude"

{
  match($0, /ore robot costs ([0-9]+) ore/, groups)
  BLUEPRINTS[NR]["ore"]["ore"] = groups[1]

  match($0, /clay robot costs ([0-9]+) ore/, groups)
  BLUEPRINTS[NR]["clay"]["ore"] = groups[1]

  match($0, /obsidian robot costs ([0-9]+) ore and ([0-9]+) clay/, groups)
  BLUEPRINTS[NR]["obsidian"]["ore"] = groups[1]
  BLUEPRINTS[NR]["obsidian"]["clay"] = groups[2]

  match($0, /geode robot costs ([0-9]+) ore and ([0-9]+) obsidian/, groups)
  BLUEPRINTS[NR]["geode"]["ore"] = groups[1]
  BLUEPRINTS[NR]["geode"]["obsidian"] = groups[2]
}

function simulate(blueprint, _) {
  reserves["ore"] = 0
  reserves["clay"] = 0
  reserves["obsidian"] = 0

  # if (canBuild(reserves, blueprint["geode"])) {

  # }

  printArray(blueprint)
}

END {
  SIMULATION_LENGTH = 24

  # printArray(BLUEPRINTS)

  for (i = 1; i <= length(BLUEPRINTS); i++) {
    simulate(BLUEPRINTS[i])
  }
}
