#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

if ! command -v "python3" &> /dev/null; then
  echo "python3 not found"
  exit 1
fi

python3 "$DIR/shared/http-server.py" ./build \
  --port 8001 \
  --route /:html \
  --route /baro-client:baro-client \
  --route /baro-server:baro-server
