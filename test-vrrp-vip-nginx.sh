#!/bin/bash
set -eu
cd $(dirname $0)
source ./lib.sh

curl http://${NGINX_VIP_ADDR}

for i in `seq 1 $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    INSTANCE_NAME=${INSTANCE_PREFIX}${i}
    echo "restart $INSTANCE_NAME"
    lxc exec $NODE_NAME -- lxc restart $INSTANCE_NAME
    curl http://${NGINX_VIP_ADDR}
done
