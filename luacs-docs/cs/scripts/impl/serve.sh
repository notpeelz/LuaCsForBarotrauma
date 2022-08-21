#!/usr/bin/env bash

set -Eeuo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

SERVE_DEFAULT_HOST="127.0.0.1"
SERVE_DEFAULT_PORT=8002
SERVE_DEFAULT_ROOT=./build
. "$DIR/shared/serve-base.sh"

parse_opts "$@"

serve \
  --route /:html \
  --route /html:html \
  --route /baro-client:baro-client \
  --route /baro-server:baro-server
