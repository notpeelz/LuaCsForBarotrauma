#!/usr/bin/env bash

set -Eeuo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. "$DIR/shared/script-base.sh"

opt_output_default="."
add_opt_with_value "output" "o" "<path>" "Directory where the output files will be written to (default: $opt_output_default)"

handle_opt() {
  case "$1" in
    --output|-o)
      opt_output="$2"
      return 1
      ;;
  esac
  return 0
}

GO_parse "$@"

opt_output="${opt_output:-$opt_output_default}"
if [[ -z "$opt_output" ]]; then
  echo "Invalid output dir"
  exit 1
fi

if ! command -v "dotnet" &> /dev/null; then
  if [[ -z "dotnet" ]]; then
    echo "dotnet not found"
  fi
  exit 1
fi

tmp_dir="$(mktemp -d)"
on_exit() {
 rm -rf -- "$tmp_dir"
}
add_hook exit on_exit

echo "Building LuaDocsGenerator"
run_task_fg dotnet publish "$DIR/LuaDocsGenerator" \
  -clp:"ErrorsOnly;Summary" \
  -o "$tmp_dir"

echo "Generating docs"
(
  mkdir -p "$opt_output"
  cd "$opt_output"
  # TODO: pass path to the Barotrauma solution dir
  run_task_fg "$tmp_dir/LuaDocsGenerator"
)
