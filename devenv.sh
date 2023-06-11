#!/usr/bin/env bash
#
# Wrapper for launching Dockerized devenv
set -euo pipefail

#===============================================================================
# Logging
#===============================================================================
RED="\033[0;31m"
GREEN="\033[0;32m"  # <-- [0 means not bold
YELLOW="\033[0;33m" # <-- [0 means bold
B_YELLOW="\033[1;33m" # <-- [1 means bold
CYAN="\033[0;36m"
MAGENTA="\033[0;35m"
NC="\e[0m"

_logger() {
  local date_time
  date_time="$(date +"%Y/%m/%d %H:%M:%S")"
  printf "${!COLOR:-$NC}"
  [[ -n "${VERBOSE:-}" ]] && printf "[${date_time}] - [${DBG_LEVEL:-}] - $@"
  [[ -z "${VERBOSE:-}" ]] && printf "[${DBG_LEVEL:-}] - $@"
  printf "${NC}\n"
}

debug() { COLOR=MAGENTA DBG_LEVEL=DEBUG _logger "$@"; }
info() { COLOR=GREEN DBG_LEVEL=INFO _logger "$@"; }
warn() { COLOR=YELLOW DBG_LEVEL=WARN _logger "$@" >&2; }
error() { COLOR=RED DBG_LEVEL=ERROR _logger "$@" >&2; }
fatal() { COLOR=RED DBG_LEVEL=FATAL _logger "💀 $@" >&2; exit 0; }

#===============================================================================

mountDir="/Users/torres/Uni/CS6200/pr1/gflib"

IMAGE="uni/devenv"
NAME="devenv"

MOUNTS=(
  "-v" "${mountDir}:/app"
)

VIRT_FLAGS=(
  "-e" "QEMU_STRACE=1"
  "--cap-add=SYS_PTRACE"
  "--security-opt=seccomp=unconfined"
  "--security-opt=apparmor=unconfined"
)

PORT_FWDS=(
  "-p" "8888:8888"
)

start_container() {
  if [[ ! $(docker ps --filter "name=^/$NAME$" --format '{{.Names}}') == $NAME ]]; then
    docker run -it -d --name "${NAME}" \
      "${VIRT_FLAGS[@]}" \
      "${MOUNTS[@]}" \
      "${PORT_FWDS[@]}" \
      "${IMAGE}" \
      /bin/bash
  fi
}

stop_container() {
  docker stop "${NAME}" || warn "Container not running"
}

restart_container() {
  stop_container && docker rm "${NAME}"
  start_container
}

exec_command() {
  docker exec -it "${NAME}" $@
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --restart )
      info "Restarting container"
      shift 1
      restart_container
      exit $?
      ;;
    -h | --help)
      echo "Devenv script"
      exit 2
      ;;
    --)
      shift;
      break
      ;;
    *)
      echo "Unexpected option: $1"
      exit 1
      ;;
  esac
done

start_container

ARGS="${@:-/bin/bash}"
exec_command "$ARGS"
