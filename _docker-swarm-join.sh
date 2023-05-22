#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

MANAGER_ADDR="$1"
TOKEN="$2"
SWARM_PORT=2377

docker swarm join --token "$TOKEN" "${MANAGER_ADDR}:${SWARM_PORT}"
