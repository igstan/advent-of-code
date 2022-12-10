#!/usr/bin/env bash

awk '/^$/ { print total; total = 0; next } { total += $1 }' input | sort -r | head -1
