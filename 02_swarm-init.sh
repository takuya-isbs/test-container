#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

NODE_1_ADDR=`get_ipv4 ${NODE_1}`

TOKEN=`lxc exec ${NODE_1} -- bash /SRC/_docker-swarm-init.sh $NODE_1_ADDR`

for i in `seq 2 $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    lxc exec ${NODE_NAME} -- bash /SRC/_docker-swarm-join.sh "$NODE_1_ADDR" "$TOKEN"
done

lxc exec ${NODE_1} -- docker node ls
