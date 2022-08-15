#!/usr/bin/env bash

if ! command -v "doxygen" &> /dev/null; then
  echo "doxygen not found"
  exit 1
fi

rm -rf ./build
mkdir -p ./build
mkdir -p ./build/baro-server
mkdir -p ./build/baro-client

echo "Building server docs"
(
  cd ./baro-server
  doxygen ./Doxyfile
)

echo "Building client docs"
(
  cd ./baro-client
  doxygen ./Doxyfile
)

echo "Building shared docs"
doxygen ./Doxyfile
