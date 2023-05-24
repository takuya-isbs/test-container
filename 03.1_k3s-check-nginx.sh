#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

lxc exec ${NODE_1} -- kubectl get svc -o wide
lxc exec ${NODE_1} -- kubectl get pods -o wide

for i in `seq $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    NODE_ADDR=`get_ipv4 $NODE_NAME`
    URL=http://${NODE_ADDR}:32080/
    curl -s $URL | wc -l
done
