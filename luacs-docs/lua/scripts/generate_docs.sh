#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$DIR/LuaDocsGenerator"

if ! command -v "dotnet" &> /dev/null; then
  if [[ -z "dotnet" ]]; then
    echo "dotnet not found"
  fi
  exit 1
fi

dotnet build /p:WarningLevel=0 /p:RunCodeAnalysis=false
dotnet run --no-build
