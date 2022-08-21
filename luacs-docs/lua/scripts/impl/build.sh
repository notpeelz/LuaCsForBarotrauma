#!/usr/bin/env bash

set -Eeuo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. "$DIR/shared/script-base.sh"

opt_src_default="."
add_opt_with_value "src" "" "<path>" "Directory of the Lua docs (default: $opt_src_default)"

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

if [[ ! -d "$opt_src/static" ]]; then
  echo "Static assets dir not found: $opt_src/static"
  exit 1
fi

ldoc_path="lua_modules/bin/ldoc"

if [[ ! -x "$ldoc_path" ]]; then
  echo "ldoc not found; please run scripts/install.sh"
  exit 1
fi

rm -rf "$opt_output"
mkdir -p "$opt_output"

cp -r "$opt_src/static"/. "$opt_output"

(
  output_path="$(realpath "$opt_output")"
  ldoc_path="$(realpath "$ldoc_path")"

  # XXX: ldoc is a little bit silly... it doesn't find our source files
  # (defined in config.ld) unless it's in the working directory
  cd "$opt_src"

  # XXX: be VERY careful not to use relative paths here;
  # we're not in the same folder anymore!

  run_task_fg "$ldoc_path" \
    -d "$output_path" \
    -c "config.ld" \
    -s "static/css" \
    .

  # FIXME: ldoc copies the stylesheet to the root of the build folder, but
  # we don't make use of it...
  rm "$output_path/ldoc.css"
)
