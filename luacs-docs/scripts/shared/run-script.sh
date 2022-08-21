#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# XXX: because this script is meant to be symlinked, it means $DIR is
# the path that contains the symlink. By passing `-C "$DIR/.."`, the script
# ends up navigating to luacs-docs/lua or luacs-docs/cs.

# XXX: this is a bit hacky, but this is the only way I found to change argv[0]
# to match the script we're masquerading as.
# In other words, this makes it so that the script sees its own name as
# `./scripts/whatever.sh` instead of `./scripts/impl/whatever.sh`

exec bash -c ". $DIR/impl/$(basename "${BASH_SOURCE[0]}")" "$0" -C "$DIR/.." "$@"
