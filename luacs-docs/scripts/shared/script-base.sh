#!/usr/bin/env bash

set -Eeuo pipefail

_SCRIPTBASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. "$_SCRIPTBASE_DIR/bash-getopt/getopt.sh"

GO_add_opt_with_value _handle_opt_working_dir "working-dir" "C" "<path>" "Executes the command as if it was ran from a different location"

_handle_opt_working_dir() {
  opt_workdir="$2"
  return 1
}

_SCRIPTBASE_on_parse() {
  opt_workdir="${opt_workdir:-$PWD}"
  if [[ ! -d "$opt_workdir" ]]; then
    echo "Invalid working dir: $opt_workdir"
    exit 1
  fi
  cd "$opt_workdir"
}

GO_add_hook parse _SCRIPTBASE_on_parse

add_opt() {
  GO_add_opt handle_opt "$@"
}

add_opt_with_value() {
  GO_add_opt_with_value handle_opt "$@"
}

parse_opts() {
  if [[ "$(type -t handle_opt)" != "function" ]]; then
    handle_opt() { :; }
  fi

  GO_parse "$@"
}

declare -a \
  _SCRIPTBASE_tasks \
  _SCRIPTBASE_exit_hooks

add_hook() {
  case "$1" in
    exit)
      _SCRIPTBASE_exit_hooks+=("$2")
      ;;
    *)
      echo "ERROR: invalid hook: $1"
      exit 1
      ;;
  esac
}

_SCRIPTBASE_on_exit() {
  _EXITCODE_=$?
  for fn in "${_SCRIPTBASE_exit_hooks[@]}"; do
    "$fn" || true
  done
  exit "$_EXITCODE_"
}

trap _SCRIPTBASE_on_exit EXIT

run_task_fg() {
  set -m
  "$@" </dev/stdin 1>/dev/stdout 2>/dev/stderr &
  task_pid="$!"
  _SCRIPTBASE_tasks+=("$task_pid")
  fg &> /dev/null

  for i in "${!_SCRIPTBASE_tasks[@]}"; do
    if [[ "${_SCRIPTBASE_tasks[i]}" == "$task_pid" ]]; then
      unset '_SCRIPTBASE_tasks[i]'
    fi
  done
}

_SCRIPTBASE_on_exit_clean_tasks() {
  for task_pid in "${_SCRIPTBASE_tasks[@]}"; do
    kill -TERM "$task_pid" &> /dev/null || true
  done
  _SCRIPTBASE_tasks=()
}

add_hook exit _SCRIPTBASE_on_exit_clean_tasks
