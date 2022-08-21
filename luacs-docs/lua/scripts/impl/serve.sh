#!/usr/bin/env bash

set -Eeuo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

SERVE_DEFAULT_HOST="127.0.0.1"
SERVE_DEFAULT_PORT=8001
SERVE_DEFAULT_ROOT=./build
. "$DIR/shared/serve-base.sh"

parse_opts "$@"

serve
