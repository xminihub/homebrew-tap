#!/usr/bin/env bash
# Print the version a formula pins (taken from its release URL), or nothing.
set -euo pipefail
name="${1:?usage: pinned-version.sh <name>}"
sed -n 's#.*/releases/download/v\([^/]*\)/.*#\1#p' "Formula/$name.rb" 2>/dev/null \
  | head -1 || true
