#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

NODE_1=${NODE_PREFIX}1
NODE_1_ADDR=`get_ipv4 ${NODE_1}`

lxc exec ${NODE_1} -- bash /SRC/_k3s-init.sh
TOKEN=`lxc exec ${NODE_1} -- bash /SRC/_k3s-get-token.sh`

for i in `seq 2 $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    lxc exec ${NODE_NAME} -- bash /SRC/_k3s-join.sh "$NODE_1_ADDR" "$TOKEN"
done

lxc exec ${NODE_1} -- kubectl get nodes

lxc exec ${NODE_1} -- kubectl apply -f /SRC/nginx-test-manifest.yml
