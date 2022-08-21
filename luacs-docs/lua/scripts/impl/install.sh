#!/usr/bin/env bash

set -Eeuo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. "$DIR/shared/script-base.sh"

add_opt_with_value "lua-binary" "" "<value>" "Path to (or the name of) the Lua binary"

handle_opt() {
  case "$1" in
    --lua-binary)
      opt_lua_bin="$2"
      return 0
      ;;
  esac
  return 1
}

parse_opts "$@"

opt_lua_bin="lua"
if ! command -v "$opt_lua_bin" &> /dev/null; then
  echo "lua not found"
  exit 1
fi

if ! command -v "luarocks" &> /dev/null; then
  echo "luarocks not found"
  exit 1
fi

lua_version="$("$opt_lua_bin" -v 2>&1 | grep -Po '^Lua \K(\d+)\.(\d+)')"
if [[ -z "$lua_version" ]]; then
  echo "Failed to extract lua version"
  exit 1
fi
echo "Detected lua version: $lua_version"

(
  # XXX: we only cd because `luarocks make` can find the rockspec file
  # automatically from the working directory
  workdir="$PWD"
  cd "$DIR/libs/ldoc"

  run_task_fg luarocks \
    --tree "$workdir/lua_modules" \
    --lua-version "$lua_version" \
    make
)
