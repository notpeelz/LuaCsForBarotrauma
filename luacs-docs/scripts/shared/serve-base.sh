DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. "$DIR/script-base.sh"

_SERVE_handle_opt() {
  case "$1" in
    --host)
      opt_host="$2"
      return 1
      ;;
    --port|-p)
      opt_port="$2"
      return 1
      ;;
  esac
  return 0
}

_SERVE_on_parse() {
  http_server_args=()

  if [[ -z "${serve_host:-}" ]]; then
    serve_host="${SERVE_HOST:-}"
  fi
  if [[ -z "${serve_host:-}" ]]; then
    serve_host="${opt_host:-$SERVE_DEFAULT_HOST}"
  fi
  if [[ -z "${serve_host:-}" ]]; then
    echo "ERROR: no host defined"
    exit 1
  fi
  http_server_args+=("--host" "$serve_host")

  if [[ -z "${serve_port:-}" ]]; then
    serve_port="${SERVE_PORT:-}"
  fi
  if [[ -z "${serve_port:-}" ]]; then
    serve_port="${opt_port:-$SERVE_DEFAULT_PORT}"
  fi
  if [[ -z "${serve_port:-}" ]]; then
    echo "ERROR: no port defined"
    exit 1
  fi
  http_server_args+=("--port" "$serve_port")

  if [[ -z "${serve_root:-}" ]]; then
    serve_root="${SERVE_ROOT:-}"
  fi
  # if SERVE_ROOT isn't defined, we assume first positional arg is the root
  if [[ -z "${serve_root:-}" ]]; then
    serve_root="${1:-$SERVE_DEFAULT_ROOT}"
  fi
  if [[ ! -d "${serve_root:-}" ]]; then
    if [[ ! -z "${serve_root:-}" ]]; then
      echo "Invalid root: $serve_root"
    fi
    GO_print_usage
    exit 1
  fi
}

GO_add_hook parse _SERVE_on_parse

SERVE_print_listening() {
  echo "Listening on http://$serve_host:$serve_port"
}

serve() {
  SERVE_print_listening
  run_task_fg python3 "$DIR/http-server.py" \
    "$serve_root" \
    "${http_server_args[@]}" \
    "$@"
}

if ! command -v "python3" &> /dev/null; then
  echo "python3 not found"
  exit 1
fi

if [[ -z "${SERVE_PORT:-}" ]]; then
  GO_add_opt_with_value _SERVE_handle_opt "port" "p" "<port>" "Port to listen on (default: $SERVE_DEFAULT_PORT)"
fi
if [[ -z "${SERVE_HOST:-}" ]]; then
  GO_add_opt_with_value _SERVE_handle_opt "host" "" "<host>" "Host to listen on (default: $SERVE_DEFAULT_HOST)"
fi

if [[ -z "${SERVE_ROOT:-}" ]]; then
  GO_USAGE="Usage: $0 <http-root>"
fi
