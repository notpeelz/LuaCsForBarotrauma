#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

if ! command -v "python3" &> /dev/null; then
  echo "python3 not found"
  exit 1
fi

python3 "$DIR/shared/http_server.py" ./build --port 8000
