#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$DIR/.."

ldoc_path=./lua_modules/bin/ldoc

if [[ ! -x "$ldoc_path" ]]; then
  echo "ldoc not found; please run docs/scripts/install.sh"
  exit 1
fi

rm -rf ./html
mkdir ./html

cp -r ./js/. ./html
cp -r ./css/. ./html

"$ldoc_path" .
