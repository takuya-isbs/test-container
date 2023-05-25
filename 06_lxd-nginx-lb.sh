#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

NODE_1_ADDR=`get_ipv4 ${NODE_1}`

INSTANCE_PREFIX=nginx-lb-

# create LXD container in LXD VM
for i in `seq 1 $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    LXD_INSTANCE=${INSTANCE_PREFIX}${i}
    lxc exec ${NODE_NAME} -- lxc delete -f $LXD_INSTANCE || IGNORE
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
    LXD_INSTANCE=${INSTANCE_PREFIX}${i}
    until lxc exec ${NODE_NAME} -- lxc exec $LXD_INSTANCE -- ping -q -4 -c 1 "$NODE_1_ADDR" > /dev/null 2>&1; do
        sleep 1
    done
done

ADDR1=`lxc exec $NODE_1 -- bash /SRC/_get_ipv4.sh ${INSTANCE_PREFIX}1 eth0`
ADDR2=`lxc exec $NODE_2 -- bash /SRC/_get_ipv4.sh ${INSTANCE_PREFIX}2 eth0`
ADDR3=`lxc exec $NODE_3 -- bash /SRC/_get_ipv4.sh ${INSTANCE_PREFIX}3 eth0`

mkdir -p ./tmp
cat <<EOF > ./tmp/nginx-vrrp.conf
NODE_1_ADDR=${ADDR1}
NODE_2_ADDR=${ADDR2}
NODE_3_ADDR=${ADDR3}
EOF

for i in `seq 1 $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    LXD_INSTANCE=${INSTANCE_PREFIX}${i}
    NODE_ID=node${i}
    lxc exec ${NODE_NAME} -- lxc exec $LXD_INSTANCE -- bash /SRC/_nginx-vrrp-setup.sh $NODE_ID &
done
wait

for i in `seq 1 $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    lxc exec ${NODE_NAME} -- lxc list
done
