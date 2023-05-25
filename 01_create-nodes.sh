#!/bin/bash
set -eux
cd $(dirname $0)
source ./lib.sh

# usage:
# delete and create: ./01_create-nodes.sh
# delete only:       ./01_create-nodes.sh DELETE

DELETE=${1:-}

wait_for_wake() {
    local NODE_NAME=$1
    until lxc exec ${NODE_NAME} -- cloud-init status --wait; do
        sleep 1
    done
    # until lxc exec ${NODE_NAME} -- ping -q -4 -c 1 ${DNS_CHECK}; do
    #     sleep 1
    # done
}

exec_retry() {
    local NODE_NAME=$1
    shift
    until lxc exec ${NODE_NAME} -- "$@"; do
        sleep 1
    done
}

validate() {
    [ $NUM_NODES -le $MAX_NUM_NODES ]
}

validate

for i in `seq $MAX_NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    lxc stop ${NODE_NAME} || IGNORE
    lxc delete ${NODE_NAME} || IGNORE
done

if [ "$DELETE" = "DELETE" ]; then
    exit 0
fi

NODE_NAME=$NODE_1
SRC_DIR=$(realpath .)

lxc profile delete $LXD_PROFILE || true
### use existing storage pool
#lxc storage delete $LXD_POOL || true
lxc network delete $LXD_NET1_NAME || true

DHCP_START=${LXD_NET1_PREFIX}${LXD_NET1_DHCP_RANGE%-*}
DHCP_END=${LXD_NET1_PREFIX}${LXD_NET1_DHCP_RANGE#*-}
lxc network create $LXD_NET1_NAME \
    ipv4.address=${LXD_NET1_PREFIX}1/24 \
    ipv4.dhcp.ranges=${DHCP_START}-${DHCP_END} \
    ipv4.nat=true || true

lxc profile create $LXD_PROFILE
lxc network attach-profile $LXD_NET1_NAME $LXD_PROFILE eth0

### use existing storage pool
#lxc storage create $LXD_POOL dir source=/var/snap/lxd/common/lxd/storage-pools/${LXD_POOL}
lxc profile device add $LXD_PROFILE root disk path=/ pool=${LXD_POOL} size=30GB
lxc profile show $LXD_PROFILE

lxc launch -p ${LXD_PROFILE} ${IMAGE} ${NODE_NAME} ${LAUNCH_OPT}
wait_for_wake ${NODE_NAME}
lxc stop ${NODE_NAME}
lxc config device add ${NODE_NAME} SRC disk source=${SRC_DIR} path=/SRC
lxc start ${NODE_NAME}
wait_for_wake ${NODE_NAME}
lxc exec ${NODE_NAME} -- bash /SRC/_install-docker.sh
lxc stop ${NODE_NAME}

for i in `seq 2 $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    lxc cp ${NODE_1} ${NODE_NAME}
    lxc start ${NODE_NAME}
done

for i in `seq 2 $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    wait_for_wake ${NODE_NAME}
    lxc exec ${NODE_NAME} -- bash /SRC/_reset-machine-id.sh
    lxc stop ${NODE_NAME}
done

for i in `seq $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    lxc start ${NODE_NAME}
done

for i in `seq $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    wait_for_wake ${NODE_NAME}
    lxc exec ${NODE_NAME} -- docker version
done
