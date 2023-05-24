#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

for i in `seq 2 $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    lxc exec ${NODE_NAME} -- k3s-agent-uninstall.sh || true
done

lxc exec ${NODE_1} -- k3s-uninstall.sh
