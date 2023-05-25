#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

NODE_1_ADDR=`get_ipv4 ${NODE_1}`

# create LXD container in LXD VM
for i in `seq 1 $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    lxc exec ${NODE_NAME} -- bash /SRC/_lxd-init.sh ${i} &
done
wait

lxc exec ${NODE_1} -- bash /SRC/_lxd-remote-init.sh
for i in `seq 2 $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    lxc exec ${NODE_NAME} -- bash /SRC/_lxd-remote-join.sh ${NODE_1}
done

lxc exec ${NODE_1} -- bash /SRC/_lxd-remote-unset.sh

for i in `seq 1 $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    lxc exec ${NODE_NAME} -- bash /SRC/_lxd-launch.sh ${i} &
done
wait

for i in `seq 1 $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    until lxc exec ${NODE_NAME} -- cloud-init status --wait; do
        sleep 1
    done
    lxc exec ${NODE_NAME} -- lxc list
done
