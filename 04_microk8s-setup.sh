#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

NODE_1_ADDR=`get_ipv4 ${NODE_1}`

for i in `seq 1 $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    lxc exec ${NODE_NAME} -- bash /SRC/_microk8s-init.sh &
done
wait

for i in `seq 2 $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    TOKEN=`lxc exec ${NODE_1} -- bash /SRC/_microk8s-get-token.sh`
    lxc exec ${NODE_NAME} -- bash /SRC/_microk8s-join.sh "$NODE_1_ADDR" "$TOKEN"
done

lxc exec ${NODE_1} -- microk8s status
lxc exec ${NODE_1} -- microk8s.kubectl get all --all-namespaces -o wide
lxc exec ${NODE_1} -- microk8s.kubectl get nodes -o wide

#lxc exec ${NODE_1} -- microk8s.kubectl apply -f /SRC/nginx-test-manifest.yml
lxc exec ${NODE_1} -- microk8s.kubectl apply -f /SRC/microbot-manifest.yml
