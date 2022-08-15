#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
# XXX: because this script is meant to be symlinked, it means $DIR is
# the path that contains the symlink. By doing `cd $DIR/..`, we end up
# navigating to luacs-docs/lua or luacs-docs/cs.
cd "$DIR/.."

"$DIR/impl/$(basename "${BASH_SOURCE[0]}")" "$@"
