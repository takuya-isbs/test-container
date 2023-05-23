#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

ADDR="$1"
TOKEN="$2"
PORT=25000

microk8s join ${ADDR}:${PORT}/${TOKEN}
