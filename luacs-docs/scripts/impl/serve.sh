#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

SERVE_DEFAULT_HOST="127.0.0.1"
SERVE_DEFAULT_PORT=8000
SERVE_ROOT=.
. "$DIR/shared/serve-base.sh"

add_opt_with_value "url" "" "<url>" "URL used to access the website (used for display purposes)"

opt_lua_root_default="lua/build"
add_opt_with_value "lua-root" "" "<path>" "Path to the Lua docs build directory (default: $opt_lua_root_default)"

opt_cs_root_default="cs/build"
add_opt_with_value "cs-root" "" "<path>" "Path to the C# docs build directory (default: $opt_cs_root_default)"

opt_root_default="landing-page"
add_opt_with_value "root" "" "<path>" "Path to the landing page directory (default: $opt_root_default)"

handle_opt() {
  case "$1" in
    --url)
      serve_url="$2"
      return 1
      ;;
    --lua-root)
      opt_lua_root="$2"
      return 1
      ;;
    --cs-root)
      opt_cs_root="$2"
      return 1
      ;;
    --root)
      opt_root="$2"
      return 1
      ;;
  esac
  return 0
}

SERVE_print_listening() {
  if [[ -z "${serve_url:-}" ]]; then
    echo "Listening on http://$serve_host:$serve_port"
  else
    echo "Listening on $serve_url"
  fi
}

parse_opts "$@"

opt_lua_root="${opt_lua_root:-$opt_lua_root_default}"
opt_cs_root="${opt_cs_root:-$opt_cs_root_default}"

opt_root="${opt_root:-$opt_root_default}"
if [[ ! -d "$opt_root" ]]; then
  echo "Invalid root dir: $opt_root"
  exit 1
fi

serve \
  --route "/:$opt_root" \
  --route "/lua-docs:$opt_lua_root" \
  --route "/cs-docs:$opt_cs_root"
