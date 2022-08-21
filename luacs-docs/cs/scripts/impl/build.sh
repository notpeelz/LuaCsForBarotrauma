#!/usr/bin/env bash

set -Eeuo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. "$DIR/shared/script-base.sh"

opt_src_default="."
add_opt_with_value "src" "" "<path>" "Directory of the C# docs (default: $opt_src_default)"

opt_output_default="build"
add_opt_with_value "output" "o" "<path>" "Directory where the output files will be written to (default: $opt_output_default)"

handle_opt() {
  case "$1" in
    --src)
      opt_src="$2"
      return 1
      ;;
    --output|-o)
      opt_output="$2"
      return 1
      ;;
  esac
  return 0
}

parse_opts "$@"

opt_src="${opt_src:-$opt_src_default}"
if [[ ! -d "$opt_src" ]]; then
  echo "Invalid source dir: $opt_src"
  exit 1
fi

opt_output="${opt_output:-$opt_output_default}"
if [[ -z "$opt_output" ]]; then
  echo "Invalid output dir"
  exit 1
fi

if ! command -v "doxygen" &> /dev/null; then
  echo "doxygen not found"
  exit 1
fi

# Make the output dir absolute so the subshells have the correct location, no
# matter where we cd into.
output_dir="$(realpath "$opt_output")"

rm -rf "$output_dir"
mkdir -p "$output_dir"
mkdir -p "$output_dir/baro-server"
mkdir -p "$output_dir/baro-client"

echo "Building server docs"
(
  cd "$opt_src/baro-server"
  run_task_fg doxygen - < <(cat ./Doxyfile <(echo "OUTPUT_DIRECTORY = $output_dir"))
)

echo "Building client docs"
(
  cd "$opt_src/baro-client"
  run_task_fg doxygen - < <(cat ./Doxyfile <(echo "OUTPUT_DIRECTORY = $output_dir"))
)

echo "Building shared docs"
(
  cd "$opt_src"
  run_task_fg doxygen - < <(cat ./Doxyfile <(echo "OUTPUT_DIRECTORY = $output_dir"))
)
