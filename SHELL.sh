#!/bin/bash
set -eu
cd $(dirname $0)
source ./lib.sh

ID=${1:-1}
shift || true

if [ $# -gt 0 ]; then
    lxc exec ${NODE_PREFIX}${ID} -- "$@"
else
    lxc exec ${NODE_PREFIX}${ID} -- bash
fi
