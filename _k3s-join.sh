#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

MANAGER_ADDR="$1"
K3S_TOKEN="$2"
K3S_PORT=6443
K3S_URL="https://${MANAGER_ADDR}:${K3S_PORT}"

curl -sfL https://get.k3s.io | K3S_URL=${K3S_URL} K3S_TOKEN=${K3S_TOKEN} sh -
