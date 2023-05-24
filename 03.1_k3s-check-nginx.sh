#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

KUBECTL="lxc exec ${NODE_1} -- kubectl"

# wait for pods running
PODS_NUM=0
while [ $PODS_NUM -lt 2 ]; do
    sleep 1
    PODS_NUM=`$KUBECTL get pods | grep "Running" | wc -l`
done

$KUBECTL get all --all-namespaces -o wide
$KUBECTL get svc -o wide
$KUBECTL get pods -o wide

for i in `seq $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    NODE_ADDR=`get_ipv4 $NODE_NAME`
    URL=http://${NODE_ADDR}:32080/
    curl -s $URL | wc -l
done
